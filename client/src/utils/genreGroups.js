/** Internal value stored in `filterSelections.genre` when a whole family is selected. */
export const GENRE_PARENT_PREFIX = '__parent:';

export const GENRE_GROUPS = [
  {
    id: 'house',
    label: 'House Family',
    members: [
      'House',
      'Deep House',
      'Tech House',
      'Bass House',
      'Afro House',
      'Latin House',
      'Melodic House',
      'Organic House',
      'Soulful House',
      'Progressive House',
      'Minimal House',
      'Future House',
      'Chicago House',
      'UK House',
      'NPC House',
      'Balearic',
      'Nu Disco',
      'Disco',
      'Italo Disco',
      'Indie Dance',
      'Amapiano',
      'UK Funky',
      'Funk',
      'Funk / Soul',
      'Soul',
    ],
  },
  {
    id: 'techno',
    label: 'Techno Family',
    members: [
      'Techno',
      'Melodic Techno',
      'Minimal Techno',
      'Hard Techno',
      'Big Room Techno',
      'Dub Techno',
      'Afro Tech',
      'Industrial',
      'Acid',
      'Progressive Techno',
    ],
  },
  {
    id: 'bass',
    label: 'Bass / UK Family',
    members: [
      'Bass',
      'Future Bass',
      'Melodic Dubstep',
      'Dubstep',
      'Riddim',
      'Trap',
      'Grime',
      'Garage',
      'Breakbeat',
      'Breakcore',
      'Jungle',
      'Drum & Bass',
      'Footwork',
      'Jersey Club',
      'Miami Bass',
      'Latin Bass',
    ],
  },
  {
    id: 'trance',
    label: 'Trance',
    members: [
      'Trance',
      'Psytrance',
    ],
  },
  {
    id: 'harddance',
    label: 'Hard Dance',
    members: [
      'Hardstyle',
      'Gabber',
    ],
  },
  {
    id: 'weird',
    label: 'Experimental / Leftfield / Weird',
    members: [
      'Electro',
      'IDM',
      'Experimental',
      'Leftfield',
      'Ambient',
      'Downtempo',
      'Indie Electronic',
      'Hyperpop',
      'Ghetto Tech',
      'Club',
    ],
  },
  {
    id: 'global',
    label: 'Global / Latin / Caribbean / Urban',
    members: [
      'Afrobeats',
      'Dancehall',
      'Reggaeton',
      'Neo Perreo',
      'Perreo',
      'Moombahton',
      'Soca',
      'Kompa',
      'Caribbean',
      'Latin',
    ],
  },
  {
    id: 'live',
    label: 'Live / Band / Non-EDM',
    members: [
      'LIVE',
      'Live Electronic',
      'Indie Pop',
      'R&B',
      'Post-Punk',
    ],
  },
  {
    id: 'nonmusic',
    label: 'Non-Music Events',
    members: [
      'Workshop',
      'Producer Workshop',
      'Industry Workshop',
      'Panel Talk',
      'Networking',
      'Open Decks',
      'Open Mic',
      'Vinyl',
    ],
  },
];

const GROUP_BY_ID = Object.fromEntries(GENRE_GROUPS.map((g) => [g.id, g]));

/** Lowercase trimmed key for comparisons. */
export function normalizeGenreName(name) {
  return String(name || '')
    .trim()
    .toLowerCase();
}

/** All member keys (normalized) across every group — for "Other" detection. */
const ALL_GROUP_MEMBER_KEYS = new Set(
  GENRE_GROUPS.flatMap((g) => g.members.map((m) => normalizeGenreName(m)))
);

export function isGenreInAnyGroup(genreName) {
  return ALL_GROUP_MEMBER_KEYS.has(normalizeGenreName(genreName));
}

/** Resolve checkbox value to the string used on events (`genreOptions` wins on casing). */
export function canonicalGenreOptionName(member, genreOptions) {
  const key = normalizeGenreName(member);
  const hit = genreOptions.find((opt) => normalizeGenreName(opt) === key);
  return hit ?? member;
}

export function parentGenreToken(groupId) {
  return `${GENRE_PARENT_PREFIX}${groupId}`;
}

export function formatGenreFilterLabel(value) {
  if (typeof value !== 'string' || !value.startsWith(GENRE_PARENT_PREFIX)) {
    return value;
  }
  const id = value.slice(GENRE_PARENT_PREFIX.length);
  return GROUP_BY_ID[id]?.label ?? value;
}

/**
 * Union of all concrete genre names (normalized) implied by current selections.
 * Selecting a parent includes every member in that family, even if not in `genreOptions`.
 */
export function expandGenreSelections(selectedValues) {
  const out = new Set();
  for (const val of selectedValues || []) {
    if (typeof val !== 'string') continue;
    if (val.startsWith(GENRE_PARENT_PREFIX)) {
      const id = val.slice(GENRE_PARENT_PREFIX.length);
      const group = GROUP_BY_ID[id];
      if (group) {
        group.members.forEach((m) => out.add(normalizeGenreName(m)));
      }
    } else {
      out.add(normalizeGenreName(val));
    }
  }
  return out;
}

export function eventMatchesGenreFilter(event, expandedNormalizedSet) {
  if (!expandedNormalizedSet || expandedNormalizedSet.size === 0) return true;
  return (event.genres || []).some((g) =>
    expandedNormalizedSet.has(normalizeGenreName(g.name))
  );
}
