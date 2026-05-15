export const PROFILE_EXTRA_BANNER_KEY = 'profileExtraInfoBannerDismissed';

export const PROFILE_EXTRA_FIELDS = [
  {
    key: 'weekends_attended',
    label: 'Movement weekends attended (including this one)',
    shortLabel: 'Weekends',
    placeholder: 'e.g. 4',
    maxLength: 40,
    inputType: 'text',
  },
  {
    key: 'hometown',
    label: 'Where are you from',
    shortLabel: 'From',
    placeholder: 'e.g. São Paulo, Brazil',
    maxLength: 100,
    inputType: 'text',
  },
  {
    key: 'artist_excited',
    label: 'Artist most excited to see',
    shortLabel: 'Excited for',
    placeholder: 'e.g. Charlotte de Witte',
    maxLength: 100,
    inputType: 'text',
  },
  {
    key: 'favorite_venue',
    label: 'Favorite venue in Detroit',
    shortLabel: 'Favorite venue',
    placeholder: 'e.g. Masonic Temple',
    maxLength: 40,
    inputType: 'text',
  },
  {
    key: 'movement_pro_tip',
    label: 'Best Movement pro-tip',
    shortLabel: 'PRO-TIP',
    placeholder: 'Your best tip for the weekend…',
    maxLength: 300,
    inputType: 'textarea',
    rows: 3,
  },
];

const MAX_LENGTH_BY_KEY = Object.fromEntries(
  PROFILE_EXTRA_FIELDS.map(({ key, maxLength }) => [key, maxLength])
);

function clipProfileExtraValue(key, value) {
  const max = MAX_LENGTH_BY_KEY[key];
  const s = String(value ?? '').trim();
  if (!max || s.length <= max) return s;
  return s.slice(0, max);
}

export function emptyProfileExtra() {
  return PROFILE_EXTRA_FIELDS.reduce((acc, { key }) => {
    acc[key] = '';
    return acc;
  }, {});
}

export function normalizeProfileExtra(raw) {
  const base = emptyProfileExtra();
  if (!raw || typeof raw !== 'object') return base;
  for (const { key } of PROFILE_EXTRA_FIELDS) {
    const v = raw[key];
    if (v != null && String(v).trim() !== '') {
      base[key] = clipProfileExtraValue(key, v);
    }
  }
  return base;
}

/** All keys sent to the API (empty string clears a stored field). */
export function profileExtraForApi(raw) {
  const base = emptyProfileExtra();
  if (!raw || typeof raw !== 'object') return base;
  for (const { key } of PROFILE_EXTRA_FIELDS) {
    base[key] = clipProfileExtraValue(key, raw[key] ?? '');
  }
  return base;
}

export function hasAnyProfileExtra(extra) {
  return PROFILE_EXTRA_FIELDS.some(({ key }) => String(extra?.[key] || '').trim() !== '');
}

/** First integer in the stored weekends value (e.g. "3", "4th year" → 4). */
export function parseWeekendsAttendedCount(value) {
  const match = String(value ?? '').trim().match(/\d+/);
  if (!match) return null;
  const n = parseInt(match[0], 10);
  return Number.isFinite(n) && n > 0 ? n : null;
}

/** rookie · regular (2–5) · veteran (6–9) · king (10+) */
export function getWeekendBadgeTier(count) {
  if (count == null || count < 1) return null;
  if (count === 1) return 'rookie';
  if (count <= 5) return 'regular';
  if (count <= 9) return 'veteran';
  return 'king';
}

export function formatMovementWeekendLabel(count) {
  const n = Math.floor(count);
  if (n < 1) return null;
  const mod100 = n % 100;
  const mod10 = n % 10;
  let suffix = 'th';
  if (mod100 < 11 || mod100 > 13) {
    if (mod10 === 1) suffix = 'st';
    else if (mod10 === 2) suffix = 'nd';
    else if (mod10 === 3) suffix = 'rd';
  }
  return `${n}${suffix} Movement Weekend`;
}

export const WEEKEND_BADGE_ICONS = {
  rookie: 'fa-solid fa-baby-carriage',
  regular: 'fa-solid fa-seedling',
  veteran: 'fa-solid fa-medal',
  king: 'fa-solid fa-crown',
};

/** Font Awesome 6 Free solid glyphs for canvas rendering. */
export const WEEKEND_BADGE_ICON_GLYPHS = {
  rookie: '\uf77d',
  regular: '\uf4d8',
  veteran: '\uf5a2',
  king: '\uf521',
};

export function getFilledProfileExtraEntries(extra) {
  return PROFILE_EXTRA_FIELDS.map(({ key, label, shortLabel }) => ({
      key,
      label,
      shortLabel,
      value: String(extra?.[key] || '').trim(),
    }))
    .filter((row) => row.value);
}

const WEEKENDS_KEY = 'weekends_attended';
const TIP_KEY = 'movement_pro_tip';

/** Split profile extra for schedule share image layout. */
export function partitionProfileExtraForShare(extra) {
  const rows = getFilledProfileExtraEntries(extra);
  const weekendRow = rows.find((row) => row.key === WEEKENDS_KEY);
  const tipRow = rows.find((row) => row.key === TIP_KEY);
  const factRows = rows.filter(
    (row) => row.key !== WEEKENDS_KEY && row.key !== TIP_KEY
  );

  let weekend = null;
  if (weekendRow) {
    const count = parseWeekendsAttendedCount(weekendRow.value);
    const tier = getWeekendBadgeTier(count);
    const label = count != null ? formatMovementWeekendLabel(count) : null;
    if (tier && label) {
      weekend = { value: weekendRow.value, count, tier, label };
    }
  }

  return {
    weekend,
    facts: factRows.map(({ shortLabel, value, key }) => ({
      shortLabel,
      value,
      key,
    })),
    proTip: tipRow?.value || null,
  };
}

export function isProfileExtraBannerDismissed() {
  try {
    return localStorage.getItem(PROFILE_EXTRA_BANNER_KEY) === '1';
  } catch {
    return false;
  }
}

export function dismissProfileExtraBanner() {
  try {
    localStorage.setItem(PROFILE_EXTRA_BANNER_KEY, '1');
  } catch {
    /* ignore */
  }
}

export function clearProfileExtraBannerDismissal() {
  try {
    localStorage.removeItem(PROFILE_EXTRA_BANNER_KEY);
  } catch {
    /* ignore */
  }
}
