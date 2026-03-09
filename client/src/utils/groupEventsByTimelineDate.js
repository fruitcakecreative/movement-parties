export function groupEventsByTimelineDate(eventList, dates, customDateRanges) {
  const MIN_OVERLAP_MS = 3 * 60 * 60 * 1000;

  const parse = (value) => (value ? new Date(value) : null);
  const getStart = (event) => parse(event.formatted_start_time || event.start_time);
  const getEnd = (event) => parse(event.formatted_end_time || event.end_time);

  const grouped = Object.fromEntries(dates.map((date) => [date, []]));

  for (const event of eventList) {
    const startStr = event.formatted_start_time || event.start_time;
    const startDay = startStr?.slice(0, 10);

    if (startDay && grouped[startDay]) {
      grouped[startDay].push(event);
    }
  }

  for (const date of dates) {
    const windowStart = parse(customDateRanges[date]?.start);
    const windowEnd = parse(customDateRanges[date]?.end);

    if (!windowStart || !windowEnd) continue;

    const existing = new Set(grouped[date].map((event) => event.id));

    for (const event of eventList) {
      const startStr = event.formatted_start_time || event.start_time;
      const startDay = startStr?.slice(0, 10);

      if (startDay === date) continue;
      if (existing.has(event.id)) continue;

      const start = getStart(event);
      if (!start) continue;

      const endReal = getEnd(event);
      const end = endReal || windowEnd;

      const overlapMs =
        Math.min(end.getTime(), windowEnd.getTime()) -
        Math.max(start.getTime(), windowStart.getTime());

      if (overlapMs >= MIN_OVERLAP_MS) {
        grouped[date].push(event);
        existing.add(event.id);
      }
    }
  }

  return grouped;
}
