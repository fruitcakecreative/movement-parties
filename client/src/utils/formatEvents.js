export function formatEvents(rawData, targetDate = '2025-05-25') {
  console.log('Formatting events from raw data...');

  const filteredEvents = rawData.filter((event) =>
    event.formatted_start_time.startsWith(targetDate)
  );

  console.log('Filtered Events for', targetDate, ':', filteredEvents);

  if (filteredEvents.length === 0) {
    console.warn('No events found for the selected date.');
    return { channels: [], epg: [] };
  }

  const venues = {};
  const eventsData = filteredEvents.map((event) => {
    if (!venues[event.venue.id]) {
      venues[event.venue.id] = {
        uuid: event.venue.id.toString(),
      };
    }
    return {
      channelUuid: event.venue.id.toString(),
      id: event.id.toString(),
      title: event.title,
      since: event.formatted_start_time,
      till: event.formatted_end_time,
      genres: event.genres,
    };
  });

  console.log('Final Channels:', Object.values(venues));
  console.log('Final Events:', eventsData);

  return { channels: Object.values(venues), epg: eventsData };
}
