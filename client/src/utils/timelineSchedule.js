/**
 * Festival "day" keys from config whose window end is still in the future.
 * After e.g. Wed 10am, Tuesday's range end has passed → key drops out of the list.
 */
export function getActiveTimelineDateKeys(customDateRanges) {
  if (!customDateRanges) return [];
  const now = Date.now();
  return Object.keys(customDateRanges).filter((key) => {
    const end = customDateRanges[key]?.end;
    if (!end) return true;
    return new Date(end).getTime() > now;
  });
}

/** Match API Event.not_past: COALESCE(end_time, start_time) > now */
export function isEventNotPast(event) {
  const end = event.end_time || event.formatted_end_time;
  const start = event.start_time || event.formatted_start_time;
  const effective = end || start;
  if (!effective) return true;
  return new Date(effective).getTime() > Date.now();
}
