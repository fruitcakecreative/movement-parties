export async function loadCityConfig() {
  const city = process.env.REACT_APP_CITY_KEY
  const res = await fetch(`${process.env.PUBLIC_URL}/${city}/config.json`, { cache: "no-store" });
  if (!res.ok) throw new Error(`Failed to load config for ${city}`);
  return res.json();
}
