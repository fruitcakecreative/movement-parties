/** Normalize one pronoun token for comparison. */
export function normalizePronounToken(raw) {
  return String(raw || '')
    .trim()
    .toLowerCase()
    .replace(/\s*\/\s*/g, '/')
    .replace(/\s+/g, ' ');
}

/** Tokens treated like he/him for filter + event-detail strike styling (comma/semicolon-separated list). */
const HE_PRESENTING = new Set([
  'he/him',
  'he/they',
  'he/him duo',
  'he/him trio',
  'he/him group',
]);

export function pronounTokens(pronouns) {
  if (pronouns == null || pronouns === '') return [];
  return String(pronouns)
    .split(/[,;]+/)
    .map((s) => normalizePronounToken(s))
    .filter(Boolean);
}

/** True if any listed token is he-presenting (he/him, he/they, he/him duo|trio|group). */
export function artistIsHePresenting(pronouns) {
  const tokens = pronounTokens(pronouns);
  if (tokens.length === 0) return false;
  return tokens.some((t) => HE_PRESENTING.has(t));
}

export function filterArtistsHideHePresenting(artists) {
  if (!Array.isArray(artists)) return [];
  return artists.filter((a) => !artistIsHePresenting(a?.pronouns));
}

/**
 * CSS row class for event details list (full lineup).
 * Priority: he presenting (struck) > she/her (pink) > she/they or they/she (purple) > they/them (yellow).
 * Only when sheTheyForwardTimeline is on (same toggle as timeline/card filter).
 */
export function artistDetailRowClass(pronouns, sheTheyForwardTimeline = false) {
  if (!sheTheyForwardTimeline) return '';
  const tokens = pronounTokens(pronouns);
  if (tokens.length === 0) return '';
  if (tokens.some((t) => HE_PRESENTING.has(t))) return 'artist-pronoun-he-struck';
  if (tokens.includes('she/her')) return 'artist-pronoun-she-her';
  if (tokens.some((t) => t === 'she/they' || t === 'they/she')) return 'artist-pronoun-she-they';
  if (tokens.includes('they/them')) return 'artist-pronoun-they-them';
  return '';
}
