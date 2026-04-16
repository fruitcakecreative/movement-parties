/**
 * Plausible custom events (script in public/index.html).
 *
 * In Plausible: Site settings → Goals → Add goal → Custom event, and enter the same
 * event name(s) you send here. If you use `props`, enable custom properties for that
 * event in Plausible (same settings area) so you can break down by `state` / `city`.
 */

export function trackPlausible(eventName, props) {
  if (typeof window === 'undefined') return;
  const plausible = window.plausible;
  if (typeof plausible !== 'function') return;
  try {
    const city = process.env.REACT_APP_CITY_KEY;
    const merged =
      props && typeof props === 'object'
        ? { ...props, ...(city ? { city } : {}) }
        : city
          ? { city }
          : null;
    if (merged && Object.keys(merged).length > 0) {
      plausible(eventName, { props: merged });
    } else {
      plausible(eventName);
    }
  } catch {
    /* ignore */
  }
}
