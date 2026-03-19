export const formatTime = (timeStr) => {
  if (!timeStr) return '';

  if (!timeStr.includes('T')) return timeStr.toLowerCase();

  const match = timeStr.match(/T(\d{2}):(\d{2})/);
  if (!match) return '';

  let hours = parseInt(match[1], 10);
  const minutes = match[2];
  const suffix = hours >= 12 ? 'pm' : 'am';

  hours = hours % 12 || 12;

  return minutes === '00' ? `${hours}${suffix}` : `${hours}:${minutes}${suffix}`;
};

export const formatDate = (timeStr) => {
  if (!timeStr) return '';

  const datePart = timeStr.split('T')[0];
  const [year, month, day] = datePart.split('-').map(Number);
  const date = new Date(year, month - 1, day);

  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
  });
};

export const getPreferredGenre = (genres = []) =>
  genres.find((genre) => {
    const name = (genre.short_name || genre.name || '').toLowerCase().trim();
    return name !== 'techno';
  }) || genres[0] || null;

export const getEventDisplayData = (
  event = {},
  { isMobile = false, isShortMobileEvent = false, isShortEvent = false } = {}
) => {
  const {
    title,
    short_title,
    start_time,
    end_time,
    venue = {},
    genres = [],
    artists = [],
    top_artists = [],
    ticket_url,
    event_url,
    event_image_url,
    attending_count,
    description,
    age,
    ticket_price,
    ticket_tier,
    ticket_wave,
    bg_color,
    font_color,
    location,
    address,
    source,
    ticket_label,
  } = event;

  let resolvedTicketTier = ticket_tier ? `– ${ticket_tier}` : '';
  const resolvedAge = age || venue?.age;

  if (ticket_wave) {
    const [current, total] = ticket_wave.split(' of ').map(Number);
    if (current === total) resolvedTicketTier = '– Final release';
  }

  const displayStartTime = formatTime(start_time);
  const displayEndTime = formatTime(end_time);
  const dateLabel = formatDate(start_time);

  const timeLabel =
    displayStartTime && displayEndTime
      ? `${displayStartTime}-${displayEndTime}`
      : displayStartTime || '';


      const resolvedTicketLabel =
    ticket_label ||
    (ticket_price === '0.0' || ticket_price === 0 || ticket_price === '0'
      ? 'FREE'
      : ticket_price
        ? `$${Number(ticket_price).toFixed(2)}`
        : '');

  let actionButtons = [];

  const isFreeTicket =
    event.ticket_price === 0 ||
    event.ticket_price === '0' ||
    event.ticket_price === '0.0' ||
    event.free_event === true;

  const ticketUrl = event.ticket_url || '';
  const eventUrl = event.event_url || '';

  const getLinkType = (url) => {
    const lowerUrl = url.toLowerCase();

    if (lowerUrl.includes('ra.co')) return 'RA';
    if (lowerUrl.includes('dice.fm') || lowerUrl.includes('dice.com')) return 'DICE';
    return 'OTHER';
  };

  if (event.ra_is_free_ticketing) {
    actionButtons.push({
      label: "RSVP / RA Event",
      url: event.event_url
    });
  } else if (event.ra_has_ticketing) {
    actionButtons.push({
      label: "Tickets / RA Event",
      url: event.event_url
    });
  } else {
    if (event.ticket_url) {
      const ticketLinkType = getLinkType(ticketUrl);

      let ticketLabel;

      if (ticketLinkType === 'RA') {
        ticketLabel = isFreeTicket ? 'RA / RSVP' : 'RA / Tickets';
      } else if (ticketLinkType === 'DICE') {
        ticketLabel = isFreeTicket ? 'DICE / RSVP' : 'DICE / Tickets';
      } else {
        ticketLabel = isFreeTicket ? 'RSVP / Event Page' : 'Tickets / Event Page';
      }

      actionButtons.push({
        label: ticketLabel,
        url: event.ticket_url
      });
    }

    if (event.event_url) {
      const eventLinkType = getLinkType(eventUrl);

      actionButtons.push({
        label:
          eventLinkType === 'RA'
            ? 'RA Event'
            : eventLinkType === 'DICE'
            ? 'DICE Event'
            : 'Event Page',
        url: event.event_url
      });
    }
  }


  const displayArtists = top_artists.length > 0 ? top_artists : artists;

  const preferredGenre = getPreferredGenre(genres);

  const visibleGenres = isShortMobileEvent || isShortEvent
    ? preferredGenre
      ? [preferredGenre]
      : []
    : genres;

  const compactStartTime = displayStartTime.replace(/(am|pm)/gi, '');
  const compactEndTime = displayEndTime.replace(/(am|pm)/gi, '');

  let ticketSaleMessage = null;

  if (event.ra_ticket_status === "upcoming" && event.ra_ticket_on_sale_at) {
    const date = new Date(event.ra_ticket_on_sale_at);

    ticketSaleMessage = `Tickets on sale ${date.toLocaleString('en-US', {
      month: 'long',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit'
    })}`;
  }

  return {
    displayTitle: isMobile && short_title ? short_title : title,
    fullTitle: title,
    dateLabel,
    timeLabel,
    displayStartTime,
    displayEndTime,
    compactStartTime,
    compactEndTime,
    venueName: venue?.name || '',
    venueClassName: venue?.name || '',
    address: address || venue?.address || '',
    location: location || venue?.location || '',
    genres,
    visibleGenres,
    preferredGenre,
    displayArtists,
    ticketLabel: resolvedTicketLabel,
    ticketTier: resolvedTicketTier,
    ticketUrl: ticket_url,
    eventUrl: event_url,
    imageSrc: event_image_url,
    attendingCount: attending_count,
    description,
    source,
    age: resolvedAge,
    cardBg: (venue?.parent_venue_id ? (venue?.bg_color || venue?.display_venue_for_json?.bg_color) : venue?.bg_color)
      || bg_color
      || '#fff',
    cardFont: (venue?.parent_venue_id ? (venue?.font_color || venue?.display_venue_for_json?.font_color) : venue?.font_color)
      || font_color
      || '#000',
    actionButtons,
    ticketSaleMessage,
  };
};
