/**
 * Group profile "user events" (attending + interested) by calendar day for display.
 * @param {{ attending?: object[], interested?: object[] }} userEvents
 * @returns { [string, { label: string, attending: object[], interested: object[] }][] }
 */
export function getSortedEventDayEntries(userEvents) {
  const attending = userEvents?.attending || [];
  const interested = userEvents?.interested || [];

  const groupEventsByDay = (events = []) =>
    events.reduce((acc, event) => {
      const start = event?.formatted_start_time || event?.start_time;
      const date = start ? new Date(start) : new Date();
      const dayKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(
        2,
        "0"
      )}-${String(date.getDate()).padStart(2, "0")}`;
      const dayLabel = date.toLocaleDateString("en-US", {
        weekday: "long",
        month: "short",
        day: "numeric",
      });

      if (!acc[dayKey]) {
        acc[dayKey] = { label: dayLabel, attending: [], interested: [] };
      }
      return acc;
    }, {});

  const grouped = groupEventsByDay([...attending, ...interested]);

  attending.forEach((event) => {
    const start = event?.formatted_start_time || event?.start_time;
    if (!start) return;
    const d = new Date(start);
    const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(
      d.getDate()
    ).padStart(2, "0")}`;
    if (!grouped[key]) return;
    grouped[key].attending.push(event);
  });

  interested.forEach((event) => {
    const start = event?.formatted_start_time || event?.start_time;
    if (!start) return;
    const d = new Date(start);
    const key = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(
      d.getDate()
    ).padStart(2, "0")}`;
    if (!grouped[key]) return;
    grouped[key].interested.push(event);
  });

  return Object.entries(grouped).sort(([a], [b]) => a.localeCompare(b));
}
