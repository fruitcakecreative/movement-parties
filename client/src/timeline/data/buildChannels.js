export function createChannels(epg) {
  const seen = new Set();
  const venues = {};
  const ordered = [];

  epg.forEach((event) => {
    const uuid = event.channelUuid;
    const venue = event.venue;

    const channel = {
      uuid: uuid,
      name: event.location_tba ? event.short_title || event.title : venue.name,
      title: event.short_title || event.title || venue.name,
      short_name: event.even_shorter_title,
      logo: venue.logo_url || null,
      subheading: venue.subheading,
      tba_class: event.location_tba ? 'tba' : '',
      location_tba: event.location_tba,
      bg_color: venue.bg_color,
      font_color: venue.font_color,
      address: venue.adresss,
      location: venue.location,
    };


    venues[uuid] = channel;

    //for events with "location TBA" make sure the channels are not considered the same
    if (event.location_tba) {
      if (!seen.has(uuid)) {
        seen.add(uuid);
        ordered.push(uuid);
      }
    } else {
      const existingIndex = ordered.indexOf(uuid);
      if (existingIndex !== -1) ordered.splice(existingIndex, 1);
      ordered.push(uuid);
    }
  });

  return ordered.map((uuid) => venues[uuid]);
}
