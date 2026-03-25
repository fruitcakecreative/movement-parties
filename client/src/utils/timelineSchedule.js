import { DateTime } from 'luxon';

/** Same as `Event::GRACE_AFTER_SCHEDULE_END` — keep schedule rows / filters aligned with the API. */
export const GRACE_AFTER_SCHEDULE_END_MS = 2 * 60 * 60 * 1000;

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
 * Festival day rows to show. Stays visible until GRACE after the window `end` (matches API + not_past),
 * so the timeline does not vanish the moment the config end passes while events are still in the list.
 */
export function getActiveTimelineDateKeys(customDateRanges, timeZone = 'America/New_York') {
  if (!customDateRanges) return [];
  const now = Date.now();
  return Object.keys(customDateRanges).filter((key) => {
    const end = customDateRanges[key]?.end;
    if (!end) return true;
    const endMs = parseRangeEndMs(end, timeZone);
    if (Number.isNaN(endMs)) return false;
    return endMs + GRACE_AFTER_SCHEDULE_END_MS > now;
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
