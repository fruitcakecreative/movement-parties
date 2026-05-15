/**
 * Group profile "user events" (attending + interested) by calendar day for display.
 * @param {{ attending?: object[], interested?: object[] }} userEvents
 * @returns { [string, { label: string, attending: object[], interested: object[] }][] }
 */
/** Resolves Rails `group_by(&:status)` payloads that use either name keys or enum ordinals (`"0"` / `"1"`). */
export function coalesceEventList(raw, ...keys) {
  if (!raw || typeof raw !== 'object') return [];
  for (const k of keys) {
    const v = raw[k];
    if (Array.isArray(v)) return v;
  }
  return [];
}

function dayKeyFromEvent(event) {
  const raw =
    event?.formatted_start_time ||
    event?.start_time ||
    event?.formatted_end_time ||
    event?.end_time;
  if (!raw) return null;
  const d = new Date(raw);
  if (Number.isNaN(d.getTime())) return null;
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(
    d.getDate()
  ).padStart(2, '0')}`;
}

function dayLabelFromKey(dayKey) {
  const [y, m, d] = dayKey.split('-').map(Number);
  if (!y || !m || !d) return dayKey;
  const date = new Date(y, m - 1, d);
  if (Number.isNaN(date.getTime())) return dayKey;
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'short',
    day: 'numeric',
  });
}

/** Parseable start instant for ordering (missing/invalid → sort last). */
export function eventStartTimestamp(event) {
  const raw =
    event?.formatted_start_time ||
    event?.start_time ||
    event?.formatted_end_time ||
    event?.end_time;
  if (!raw) return Number.POSITIVE_INFINITY;
  const t = new Date(raw).getTime();
  return Number.isNaN(t) ? Number.POSITIVE_INFINITY : t;
}

export function sortEventsByStartTime(events) {
  return [...(events || [])].sort(
    (a, b) => eventStartTimestamp(a) - eventStartTimestamp(b)
  );
}

export function getSortedEventDayEntries(userEvents) {
  const raw = userEvents || {};
  const attendingList = coalesceEventList(raw, 'attending', '1', 1);
  const interestedList = coalesceEventList(raw, 'interested', '0', 0);

  const grouped = {};

  const ensure = (dayKey) => {
    if (!grouped[dayKey]) {
      grouped[dayKey] = { label: dayLabelFromKey(dayKey), attending: [], interested: [] };
    }
  };

  for (const event of attendingList) {
    const dayKey = dayKeyFromEvent(event);
    if (!dayKey) continue;
    ensure(dayKey);
    grouped[dayKey].attending.push(event);
  }

  for (const event of interestedList) {
    const dayKey = dayKeyFromEvent(event);
    if (!dayKey) continue;
    ensure(dayKey);
    grouped[dayKey].interested.push(event);
  }

  return Object.entries(grouped)
    .map(([dayKey, dayData]) => [
      dayKey,
      {
        ...dayData,
        attending: sortEventsByStartTime(dayData.attending),
        interested: sortEventsByStartTime(dayData.interested),
      },
    ])
    .filter(([, v]) => v.attending.length > 0 || v.interested.length > 0)
    .sort(([a], [b]) => a.localeCompare(b));
}
