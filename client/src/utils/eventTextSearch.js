/**
 * Case-insensitive match on event title fields, venue name, and artist names.
 * @param {object} event
 * @param {string} rawQuery
 */
export function eventMatchesTextSearch(event, rawQuery) {
  const q = String(rawQuery || "").trim().toLowerCase();
  if (!q) return true;

  const parts = [
    event.title,
    event.short_title,
    event.even_shorter_title,
    event.venue?.name,
    event.venue?.subheading,
    ...(event.artists || []).map((a) => a?.name),
    ...(event.top_artists || []).map((a) => a?.name),
  ]
    .filter(Boolean)
    .map((s) => String(s).toLowerCase());

  const hay = parts.join(" ");
  if (hay.includes(q)) return true;

  const tokens = q.split(/\s+/).filter(Boolean);
  if (tokens.length <= 1) return false;
  return tokens.every((t) => hay.includes(t));
}
