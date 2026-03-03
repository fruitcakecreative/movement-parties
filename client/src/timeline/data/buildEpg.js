export function createEpg(events) {
  return events
    .sort((a, b) => {
      const endA = new Date(a.formatted_end_time);
      const endB = new Date(b.formatted_end_time);
      return endA - endB || new Date(a.formatted_start_time) - new Date(b.formatted_start_time);
    })
    .map((event) => {
      if (!event.formatted_start_time || !event.formatted_end_time) {
        console.warn('Skipping event due to missing time:', event);
        return null;
      }

      const start = new Date(event.formatted_start_time);
      const end = new Date(event.formatted_end_time);

      if (isNaN(start.getTime()) || isNaN(end.getTime())) {
        console.warn('Skipping event due to invalid time:', event);
        return null;
      }

      const isTBA =
        event.venue.name?.toLowerCase().includes('tba') ||
        event.venue.name?.toLowerCase().includes('secret');

      const formatToHourLabel = (dateString) => {
        const [, timePart] = dateString.split('T');
        let [hour, minute] = timePart.split(':').map(Number);
        const ampm = hour >= 12 ? 'pm' : 'am';
        hour = hour % 12 || 12;
        return minute === 0 ? `${hour}${ampm}` : `${hour}:${minute}${ampm}`;
      };

      let tierLabel = event.ticket_tier ? `– ${event.ticket_tier}` : '';

      if (event.ticket_wave) {
        const [current, total] = event.ticket_wave.split(' of ').map(Number);
        if (current === total) tierLabel = '– Final release';
      }

      return {
        ...event,
        channelUuid: isTBA ? `${event.venue.name}_${event.id}` : event.venue.id.toString(),
        id: event.id.toString(),
        location_tba: isTBA,
        since: event.formatted_start_time,
        till: event.formatted_end_time,
        start_time: formatToHourLabel(event.start_time),
        end_time: formatToHourLabel(event.end_time),
        ticket_label: event.ticket_price === '0.0' ? 'FREE' : `$${event.ticket_price}`,
        tier_label: tierLabel,
        ...(isTBA
          ? {
              bg_color: event.bg_color || '#fff',
              font_color: event.font_color || '#111',
            }
          : {
              bg_color: event.venue.bg_color || '#fff',
              font_color: event.venue.font_color || '#000',
            }),
      };
    })
    .filter((event) => event !== null);
}
