import { DateTime } from 'luxon';

function isoStringHasExplicitZone(isoLike) {
  const s = String(isoLike).trim();
  return /[zZ]$|[+-]\d{2}:\d{2}$|[+-]\d{4}$/.test(s);
}

/**
 * API `formatted_*` are naive wall times in Rails `Time.zone`; JSON `start_time` / `end_time` usually have Z.
 * Naive strings must not use the browser's local zone or events disappear "early" off the west coast.
 */
export function parseEventInstant(isoStr, timeZone = 'America/New_York') {
  const s = String(isoStr).trim().replace(' ', 'T');
  if (isoStringHasExplicitZone(s)) {
    return DateTime.fromISO(s, { setZone: true });
  }
  return DateTime.fromISO(s, { zone: timeZone });
}

/** Inclusive: 12:01am through 3:30am (festival wall clock). Excludes exactly midnight. */
const LATE_NIGHT_END_MINUTE = 3 * 60 + 30;

/**
 * After-midnight starts (12:01am–3:30am festival time): previous calendar day's weekday
 * for inline copy (e.g. "actually thursday" next to the time). Null if outside the window.
 */
export function getLateNightActuallyWeekday(rawStartIso, timeZone = 'America/New_York') {
  const dt = parseEventInstant(rawStartIso || '', timeZone);
  if (!dt.isValid) return null;
  const zoned = dt.setZone(timeZone);
  const totalMin = zoned.hour * 60 + zoned.minute;
  if (totalMin < 1 || totalMin > LATE_NIGHT_END_MINUTE) return null;

  return zoned.minus({ days: 1 }).setLocale('en-US').toFormat('cccc').toLowerCase();
}

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
 * Festival day rows to show: only while `now` is still before that row's configured `end` in the
 * festival zone (no extra grace — once the schedule says 10am, the row drops after 10am).
 * API `not_past` still uses its own grace for which events are returned.
 */
export function getActiveTimelineDateKeys(customDateRanges, timeZone = 'America/New_York') {
  if (!customDateRanges) return [];
  const now = Date.now();
  return Object.keys(customDateRanges).filter((key) => {
    const end = customDateRanges[key]?.end;
    if (!end) return true;
    const endMs = parseRangeEndMs(end, timeZone);
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
