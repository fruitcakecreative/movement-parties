import { DateTime } from 'luxon';

/**
 * Parse config strings like "2026-03-25T10:00:00" (no Z) as wall-clock time in the
 * festival timezone. Uses Luxon so behavior matches across browsers (Intl-only parsers
 * were flaky in Safari / some prod builds).
 */
export function parseRangeEndMs(isoLocal, timeZone) {
  const dt = DateTime.fromISO(String(isoLocal).trim(), { zone: timeZone });
  if (!dt.isValid) return NaN;
  return dt.toMillis();
}

/**
 * Festival "day" keys whose window **end** (in festival local time) is still in the future.
 */
export function getActiveTimelineDateKeys(customDateRanges, timeZone = 'America/New_York') {
  if (!customDateRanges) return [];
  const now = Date.now();
  return Object.keys(customDateRanges).filter((key) => {
    const end = customDateRanges[key]?.end;
    if (!end) return true;
    const endMs = parseRangeEndMs(end, timeZone);
    // Invalid parse: do not keep the day forever (old NaN→true left "Tuesday" stuck in prod).
    if (Number.isNaN(endMs)) return false;
    return endMs > now;
  });
}

/** Short label for a timeline row key, in the festival zone (not the viewer's zone). */
export function formatFestivalDayShort(dateKey, timeZone = 'America/New_York') {
  const dt = DateTime.fromISO(`${dateKey}T12:00:00`, { zone: timeZone });
  if (!dt.isValid) {
    return new Date(`${dateKey}T12:00:00`).toLocaleDateString('en-US', {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
    });
  }
  return dt.setLocale('en-US').toFormat('EEE, MMM d');
}

/** Long weekday (e.g. empty-state copy). */
export function formatFestivalDayLong(dateKey, timeZone = 'America/New_York') {
  const dt = DateTime.fromISO(`${dateKey}T12:00:00`, { zone: timeZone });
  if (!dt.isValid) {
    return new Date(`${dateKey}T12:00:00`).toLocaleDateString('en-US', {
      weekday: 'long',
      month: 'short',
      day: 'numeric',
    });
  }
  return dt.setLocale('en-US').toFormat('cccc, MMM d');
}

/** Match API Event.not_past: still show until GRACE_MS after effective end (see Event::GRACE_AFTER_SCHEDULE_END). */
const GRACE_AFTER_END_MS = 2 * 60 * 60 * 1000;

export function isEventNotPast(event) {
  const end = event.end_time || event.formatted_end_time;
  const start = event.start_time || event.formatted_start_time;
  const effective = end || start;
  if (!effective) return true;
  return new Date(effective).getTime() > Date.now() - GRACE_AFTER_END_MS;
}
