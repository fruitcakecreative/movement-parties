/**
 * Resolve API event id from timeline EPG rows, DOM attrs, or profile event objects.
 * Planby rows use composite ids like "123_row_0" while `event_id` holds the real id.
 */
export function normalizeEventId(raw) {
  if (raw == null || raw === '') return null;

  if (typeof raw === 'number') {
    return Number.isFinite(raw) && raw > 0 ? raw : null;
  }

  const s = String(raw).trim();
  if (s === '' || s === 'null' || s === 'undefined') return null;

  if (/^\d+$/.test(s)) {
    const n = Number(s);
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  const rowMatch = s.match(/^(\d+)_row_\d+$/);
  if (rowMatch) {
    const n = Number(rowMatch[1]);
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  const lead = s.match(/^(\d+)/);
  if (lead) {
    const n = Number(lead[1]);
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  return null;
}
