import { DateTime } from 'luxon';
import { parseEventInstant } from './timelineSchedule';

function parseWindowBound(isoLocal, timeZone) {
  const dt = DateTime.fromISO(String(isoLocal).trim(), { zone: timeZone });
  return dt.isValid ? dt : null;
}

/**
 * Assign each event to festival-day rows. Uses the same wall-time semantics as the API
 * (`formatted_*` naive in Rails zone) so we don't rely on `new Date(naive)` (browser local)
 * or `start_time` UTC date slices that land on the wrong calendar day.
 *
 * Rows use **overlap only** with each row's config window (not calendar start date). After-
 * parties Fri 3am–9am stay on the row that ends Fri 10am, not the row that starts Fri 10am.
 */
export function groupEventsByTimelineDate(
  eventList,
  dates,
  customDateRanges,
  timeZone = 'America/New_York'
) {
  const getStartMillis = (event) => {
    const raw = event.formatted_start_time || event.start_time;
    if (!raw) return null;
    const dt = parseEventInstant(raw, timeZone);
    return dt.isValid ? dt.toMillis() : null;
  };

  const getEndMillis = (event, fallbackEnd) => {
    const raw = event.formatted_end_time || event.end_time;
    if (!raw) return fallbackEnd != null ? fallbackEnd : null;
    const dt = parseEventInstant(raw, timeZone);
    return dt.isValid ? dt.toMillis() : null;
  };

  const grouped = Object.fromEntries(dates.map((date) => [date, []]));

  for (const date of dates) {
    const wStart = parseWindowBound(customDateRanges[date]?.start, timeZone);
    const wEnd = parseWindowBound(customDateRanges[date]?.end, timeZone);
    if (!wStart || !wEnd) continue;

    const wStartMs = wStart.toMillis();
    const wEndMs = wEnd.toMillis();

    for (const event of eventList) {
      const startMs = getStartMillis(event);
      if (startMs == null) continue;

      const endMs = getEndMillis(event, wEndMs) ?? wEndMs;

      const overlapMs = Math.min(endMs, wEndMs) - Math.max(startMs, wStartMs);
      if (overlapMs > 0) {
        grouped[date].push(event);
      }
    }
  }

  return grouped;
}
