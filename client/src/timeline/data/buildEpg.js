export function createEpg(events) {
  const ONE_HOUR_MS = 60 * 60 * 1000;
  const validEvents = events.filter((event) => {
    if (!event.formatted_start_time || !event.formatted_end_time) {
      console.warn('Skipping event due to missing time:', event);
      return false;
    }

    const start = new Date(event.formatted_start_time);
    const end = new Date(event.formatted_end_time);


    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      console.warn('Skipping event due to invalid time:', event);
      return false;
    }

    return true;
  });

  const groupedByVenue = {};

  validEvents.forEach((event) => {
    const isTBA =
      event.venue.name?.toLowerCase().includes('tba') ||
      event.venue.name?.toLowerCase().includes('secret');

    const key = isTBA ? `tba-${event.id}` : event.venue.id.toString();

    if (!groupedByVenue[key]) groupedByVenue[key] = [];
    groupedByVenue[key].push(event);
  });

  const epg = [];

  Object.values(groupedByVenue).forEach((venueEvents) => {
    const sortedVenueEvents = [...venueEvents].sort(
      (a, b) => new Date(a.formatted_start_time) - new Date(b.formatted_start_time)
    );

    const firstEvent = sortedVenueEvents[0];
    const isTBA =
      firstEvent.venue.name?.toLowerCase().includes('tba') ||
      firstEvent.venue.name?.toLowerCase().includes('secret');

    const rowAnchors = [sortedVenueEvents[0]];

    if (!isTBA) {
      let lastEnd = new Date(sortedVenueEvents[0].formatted_end_time);

      for (let i = 1; i < sortedVenueEvents.length; i++) {
        const currentEvent = sortedVenueEvents[i];
        const start = new Date(currentEvent.formatted_start_time);
        const gap = start.getTime() - lastEnd.getTime();

        if (gap > ONE_HOUR_MS) {
          rowAnchors.push(currentEvent);
        }

        lastEnd = new Date(currentEvent.formatted_end_time);
      }
    }

    rowAnchors.forEach((anchorEvent, rowIndex) => {
      sortedVenueEvents.forEach((event) => {
        const durationHours =
        (new Date(event.formatted_end_time) - new Date(event.formatted_start_time)) /
        (1000 * 60 * 60);

        epg.push({
          ...event,
          channelUuid: isTBA
            ? `${event.venue.name}_${event.id}`
            : `${event.venue.id}_row_${rowIndex}`,
          id: isTBA ? event.id.toString() : `${event.id}_row_${rowIndex}`,
          event_id: event.id,
          location_tba: isTBA,
          since: event.formatted_start_time,
          till: event.formatted_end_time,
          age: event.age || event.venue?.age,
          duration: durationHours,
          channel_anchor_since: anchorEvent.formatted_start_time,
          ...(isTBA
            ? {
                bg_color: event.bg_color || '#fff',
                font_color: event.font_color || '#111',
              }
            : (() => {
                const dv = event.venue?.display_venue_for_json;
                const isChild = dv && event.venue?.parent_venue_id;
                return {
                  bg_color: (isChild ? (event.venue.bg_color || dv.bg_color) : event.venue.bg_color) || '#fff',
                  font_color: (isChild ? (event.venue.font_color || dv.font_color) : event.venue.font_color) || '#000',
                };
              })()),
        });
      });
    });
  });

  return epg.sort((a, b) => {
    const endA = new Date(a.till);
    const endB = new Date(b.till);
    return endA - endB || new Date(a.since) - new Date(b.since);
  });
}
