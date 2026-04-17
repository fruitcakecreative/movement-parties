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
  'doesnt use pronouns',
  "doesn't use pronouns",
]);

export function pronounTokens(pronouns) {
  if (pronouns == null || pronouns === '') return [];
  return String(pronouns)
    .split(/[,;]+/)
    .map((s) => normalizePronounToken(s))
    .filter(Boolean);
}

/** True if any listed token is he-presenting (he/him, he/they, he/him duo|trio|group, doesnt use pronouns, …). */
export function artistIsHePresenting(pronouns) {
  const tokens = pronounTokens(pronouns);
  if (tokens.length === 0) return false;
  return tokens.some((t) => HE_PRESENTING.has(t));
}

export function filterArtistsHideHePresenting(artists) {
  if (!Array.isArray(artists)) return [];
  return artists.filter((a) => !artistIsHePresenting(a?.pronouns));
}

/** Billings that net neutral for she/they % and sort between main lineup and he-presenting. */
const MIXED_NEUTRAL_LINEUP = new Set(['mixed duo', 'mixed group']);

function tokensHasMixedNeutralLineup(tokens) {
  return tokens.some((t) => MIXED_NEUTRAL_LINEUP.has(t));
}

/**
 * CSS row class for event details list (full lineup).
 * Priority: he presenting (struck) > mixed duo/group (neutral) > she/her (pink) > she/they or they/she (purple) > they/them or xe/xyr (yellow).
 * Only when sheTheyForwardTimeline is on (same toggle as timeline/card filter).
 */
/** Pronoun rows styled like she/they-forward (purple) — includes she/her/ela and she/her duo. */
function tokenIsSheTheyForwardGroup(t) {
  return (
    t === 'she/they' ||
    t === 'they/she' ||
    t === 'she/her/ela' ||
    t === 'she/her duo'
  );
}

function tokenIsTheyThemStyleRow(t) {
  return t === 'they/them' || t === 'xe/xyr';
}

export function artistDetailRowClass(pronouns, sheTheyForwardTimeline = false) {
  if (!sheTheyForwardTimeline) return '';
  const tokens = pronounTokens(pronouns);
  if (tokens.length === 0) return '';
  if (tokens.some((t) => HE_PRESENTING.has(t))) return 'artist-pronoun-he-struck';
  if (tokensHasMixedNeutralLineup(tokens)) return 'artist-pronoun-mixed-duo';
  if (tokens.includes('she/her')) return 'artist-pronoun-she-her';
  if (tokens.some(tokenIsSheTheyForwardGroup)) return 'artist-pronoun-she-they';
  if (tokens.some(tokenIsTheyThemStyleRow)) return 'artist-pronoun-they-them';
  return '';
}

/**
 * Sort key for No Boys event lineup: main she/they-forward rows (0), mixed duo/group (1), he-presenting (2).
 */
export function artistSheTheyListSortRank(pronouns) {
  if (artistIsHePresenting(pronouns)) return 2;
  if (tokensHasMixedNeutralLineup(pronounTokens(pronouns))) return 1;
  return 0;
}

/**
 * Share of lineup that is she/they-forward, using **slots** so mixed billings count fairly:
 * - Each normal artist = 1 slot (forward if not he-presenting).
 * - `mixed duo` = 2 slots (1 she/they-forward, 1 he).
 * - `mixed group` = 3 slots (1 she/they-forward, 2 he).
 * `unknown` is still omitted (no slots). Returns null when there are no countable slots.
 */
export function sheTheyForwardLineupPercent(artists) {
  const list = Array.isArray(artists) ? artists : [];
  let totalSlots = 0;
  let forwardSlots = 0;

  for (const a of list) {
    const tokens = pronounTokens(a?.pronouns);
    if (tokens.length === 0) continue;
    if (tokens.includes('unknown')) continue;

    if (tokens.includes('mixed group')) {
      totalSlots += 3;
      forwardSlots += 1;
      continue;
    }
    if (tokens.includes('mixed duo')) {
      totalSlots += 2;
      forwardSlots += 1;
      continue;
    }

    totalSlots += 1;
    if (!artistIsHePresenting(a?.pronouns)) {
      forwardSlots += 1;
    }
  }

  if (totalSlots === 0) return null;
  return Math.round((forwardSlots / totalSlots) * 100);
}

/**
 * Shared tier for timeline % chip and card/detail badges. `zero` is 0%; otherwise tier-low … tier-hot.
 */
export function sheTheyPctTierClassSuffix(pct) {
  if (pct == null || Number.isNaN(pct)) return null;
  if (pct === 0) return 'zero';
  if (pct >= 75) return 'tier-hot';
  if (pct >= 50) return 'tier-upper';
  if (pct >= 25) return 'tier-mid';
  return 'tier-low';
}

/** e.g. `program-she-they-pct program-she-they-pct--tier-low` */
export function programSheTheyPctClassName(pct) {
  const s = sheTheyPctTierClassSuffix(pct);
  if (s == null) return 'program-she-they-pct';
  return s === 'zero'
    ? 'program-she-they-pct program-she-they-pct--zero'
    : `program-she-they-pct program-she-they-pct--${s}`;
}

/** e.g. `she-they-lineup-pct-badge she-they-lineup-pct-badge--tier-low` */
export function sheTheyLineupPctBadgeClassName(pct) {
  const s = sheTheyPctTierClassSuffix(pct);
  if (s == null) return 'she-they-lineup-pct-badge';
  return `she-they-lineup-pct-badge she-they-lineup-pct-badge--${s}`;
}
