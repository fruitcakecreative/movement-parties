/**
 * Parse config strings like "2026-03-25T10:00:00" (no Z) as **wall-clock time in the
 * festival timezone**, not the viewer's browser local zone. That way "Tuesday" drops
 * exactly when Wednesday 10:00 hits in Miami/Detroit, regardless of where the user is.
 */
function wallClockInZoneToUtcMs(isoLocal, timeZone) {
  const m = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?/.exec(isoLocal?.trim());
  if (!m) return NaN;
  const Y = +m[1];
  const Mo = +m[2];
  const D = +m[3];
  const h = +m[4];
  const min = +m[5];
  const s = m[6] != null ? +m[6] : 0;

  const fmt = new Intl.DateTimeFormat('en-GB', {
    timeZone,
    year: 'numeric',
    month: 'numeric',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
    hour12: false,
  });

  function readParts(ms) {
    const raw = fmt.formatToParts(new Date(ms));
    const parts = {};
    for (const p of raw) {
      if (p.type !== 'literal') parts[p.type] = p.value;
    }
    return {
      y: +parts.year,
      mo: +parts.month,
      d: +parts.day,
      h: +parts.hour,
      min: +parts.minute,
      s: +parts.second,
    };
  }

  function cmpWall(w) {
    if (w.y !== Y) return w.y - Y;
    if (w.mo !== Mo) return w.mo - Mo;
    if (w.d !== D) return w.d - D;
    if (w.h !== h) return w.h - h;
    if (w.min !== min) return w.min - min;
    return w.s - s;
  }

  let lo = Date.UTC(Y, Mo - 1, D, h, min, s) - 48 * 3600 * 1000;
  let hi = Date.UTC(Y, Mo - 1, D, h, min, s) + 48 * 3600 * 1000;

  for (let i = 0; i < 56; i++) {
    const mid = Math.floor((lo + hi) / 2);
    const w = readParts(mid);
    const c = cmpWall(w);
    if (c === 0) return mid;
    if (c < 0) lo = mid + 1;
    else hi = mid - 1;
  }
  return NaN;
}

function parseRangeEndMs(endIso, timeZone) {
  const zoned = wallClockInZoneToUtcMs(endIso, timeZone);
  if (!Number.isNaN(zoned)) return zoned;
  return new Date(endIso).getTime();
}

/**
 * Festival "day" keys whose window **end** (in festival local time) is still in the future.
 * Example: Tuesday's row uses end "2026-03-25T10:00:00" → hidden once that instant passes
 * in `timeZone` (e.g. America/New_York), not in the user's laptop timezone.
 */
export function getActiveTimelineDateKeys(customDateRanges, timeZone = 'America/New_York') {
  if (!customDateRanges) return [];
  const now = Date.now();
  return Object.keys(customDateRanges).filter((key) => {
    const end = customDateRanges[key]?.end;
    if (!end) return true;
    const endMs = parseRangeEndMs(end, timeZone);
    if (Number.isNaN(endMs)) return true;
    return endMs > now;
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
