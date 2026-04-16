const STORAGE_KEY = 'sheTheyForwardTimeline';
const STORAGE_KEY_OVER50 = 'sheTheyOver50Lineup';
const HTML_ATTR = 'data-she-they-theme';

export function readSheTheyForwardEnabled() {
  if (typeof window === 'undefined') return false;
  try {
    return sessionStorage.getItem(STORAGE_KEY) === '1';
  } catch {
    return false;
  }
}

export function readSheTheyOver50LineupEnabled() {
  if (typeof window === 'undefined') return false;
  try {
    return sessionStorage.getItem(STORAGE_KEY_OVER50) === '1';
  } catch {
    return false;
  }
}

export function applySheTheyThemeToDocument(enabled) {
  if (typeof document === 'undefined') return;
  const root = document.documentElement;
  if (enabled) {
    root.setAttribute(HTML_ATTR, 'on');
  } else {
    root.removeAttribute(HTML_ATTR);
  }
}

export function persistSheTheyForward(enabled) {
  try {
    if (enabled) {
      sessionStorage.setItem(STORAGE_KEY, '1');
    } else {
      sessionStorage.removeItem(STORAGE_KEY);
      sessionStorage.removeItem(STORAGE_KEY_OVER50);
    }
  } catch {
    /* private mode */
  }
}

export function persistSheTheyOver50Lineup(enabled) {
  try {
    if (enabled) {
      sessionStorage.setItem(STORAGE_KEY_OVER50, '1');
    } else {
      sessionStorage.removeItem(STORAGE_KEY_OVER50);
    }
  } catch {
    /* private mode */
  }
}

/** Keep <html> attribute + sessionStorage aligned (entire-site theme). */
export function syncSheTheyForwardState(enabled) {
  applySheTheyThemeToDocument(enabled);
  persistSheTheyForward(enabled);
}

/** Persist “50%+ lineup only” sub-filter (No Boys must be on to mean anything). */
export function syncSheTheyOver50State(enabled) {
  persistSheTheyOver50Lineup(enabled);
}
