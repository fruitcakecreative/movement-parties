export function createChannels(epg) {
  const seen = new Set();
  const venues = {};
  const ordered = [];

  epg.forEach((event) => {
    const uuid = event.channelUuid;
    const venue = event.venue;
    const displayVenue = venue?.display_venue_for_json;
    const isChildVenue = displayVenue && venue?.parent_venue_id;

    // Use parent venue's logo, colors, name when this is a child venue; subheading = child name/subheading
    const logo = isChildVenue ? (venue.logo_url || displayVenue.logo_url) : (venue.logo_url || null);
    const bgColor = isChildVenue ? (displayVenue.bg_color || venue.bg_color) : venue.bg_color;
    const fontColor = isChildVenue ? (displayVenue.font_color || venue.font_color) : venue.font_color;
    const channelName = isChildVenue ? displayVenue.name : venue.name;
    const subheading = isChildVenue ? (venue.subheading || venue.name) : venue.subheading;

    const channel = {
      uuid: uuid,
      id: venue.id,
      name: event.location_tba ? event.short_title || event.title : channelName,
      title: event.short_title || event.title || channelName,
      short_name: event.even_shorter_title,
      logo: logo || null,
      subheading: subheading,
      tba_class: event.location_tba ? 'tba' : '',
      location_tba: event.location_tba,
      bg_color: bgColor,
      font_color: fontColor,
      address: venue.address,
      location: venue.location,
      anchorSince: event.channel_anchor_since || event.since,
      venue_type: venue.venue_type,
      age: venue.age,
      groupKey: isChildVenue ? displayVenue.id : venue.id,
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

  const channelList = Object.values(venues);
  const byGroup = {};
  channelList.forEach((ch) => {
    const key = ch.groupKey ?? ch.id;
    if (!byGroup[key]) byGroup[key] = [];
    byGroup[key].push(ch);
  });
  Object.values(byGroup).forEach((group) => {
    group.sort((a, b) => new Date(a.anchorSince) - new Date(b.anchorSince));
  });
  const groupEarliest = (group) =>
    Math.min(...group.map((ch) => new Date(ch.anchorSince).getTime()));
  const sortedGroups = Object.values(byGroup).sort(
    (ga, gb) => groupEarliest(ga) - groupEarliest(gb)
  );
  return sortedGroups.flat();
}
