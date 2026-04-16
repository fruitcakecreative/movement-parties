const WEEK_MS = 7 * 24 * 60 * 60 * 1000;

/** True when the event row was first created within the last 7 days (API `created_at`). */
export function eventCreatedInLastWeek(event) {
  const raw = event?.created_at;
  if (raw == null || raw === '') return false;
  const t = new Date(raw).getTime();
  if (Number.isNaN(t)) return false;
  return Date.now() - t <= WEEK_MS;
}
