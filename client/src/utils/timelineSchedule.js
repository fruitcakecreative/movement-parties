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
 *
 * When `showAllDays` is true (e.g. `showAllTimelineDays` in city config), every configured day
 * is shown in chronological order — for archive / post-festival browsing.
 */
export function getActiveTimelineDateKeys(
  customDateRanges,
  timeZone = 'America/New_York',
  showAllDays = false
) {
  if (!customDateRanges) return [];
  const keys = Object.keys(customDateRanges);
  if (showAllDays) {
    return keys.sort();
  }
  const now = Date.now();
  return keys.filter((key) => {
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

const DATE_KEY_RE = /^\d{4}-\d{2}-\d{2}/;

/**
 * Timeline row keys are a festival calendar day (`YYYY-MM-DD`). The row’s window often crosses
 * midnight (e.g. Fri noon → Sat noon). Events that **start** on the **next** calendar day in
 * `timeZone` at **04:00 or later** are treated as the next row’s programme only — not this row’s.
 * Starts from midnight up to 03:59:59.999 on that next day still appear on this row (after-parties).
 */
export function isEventHiddenFromTimelineRowByNextDayFourAm(
  event,
  timelineDateKey,
  timeZone = 'America/New_York'
) {
  const raw = event?.formatted_start_time || event?.start_time;
  if (!raw || !timelineDateKey) return false;

  const keyMatch = String(timelineDateKey).match(DATE_KEY_RE);
  if (!keyMatch) return false;

  const start = parseEventInstant(raw, timeZone);
  if (!start.isValid) return false;

  const rowDay = DateTime.fromISO(keyMatch[0], { zone: timeZone }).startOf('day');
  if (!rowDay.isValid) return false;

  const cutoff = rowDay.plus({ days: 1 }).set({ hour: 4, minute: 0, second: 0, millisecond: 0 });
  const startLocal = start.setZone(timeZone);
  return startLocal >= cutoff;
}

/**
 * Row calendar date `D` (`YYYY-MM-DD`). If the event **ends** in `timeZone` still on **that same
 * calendar date** and at **11:00 or earlier** (through 11:00:00), omit from this row — those
 * endings read as the tail of the prior festival window, not this row’s programme.
 */
export function isEventHiddenFromTimelineRowBySameDayEndThroughElevenAm(
  event,
  timelineDateKey,
  timeZone = 'America/New_York'
) {
  const raw = event?.formatted_end_time || event?.end_time;
  if (!raw || !timelineDateKey) return false;

  const keyMatch = String(timelineDateKey).match(DATE_KEY_RE);
  if (!keyMatch) return false;

  const end = parseEventInstant(raw, timeZone);
  if (!end.isValid) return false;

  const endLocal = end.setZone(timeZone);
  const rowDate = keyMatch[0];
  if (endLocal.toISODate() !== rowDate) return false;

  const rowDayStart = DateTime.fromISO(rowDate, { zone: timeZone }).startOf('day');
  if (!rowDayStart.isValid) return false;

  const elevenAm = rowDayStart.plus({ hours: 11 });
  return endLocal <= elevenAm;
}
