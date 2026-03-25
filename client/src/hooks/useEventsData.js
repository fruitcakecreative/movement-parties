import { useEffect, useState } from 'react';
import * as Sentry from '@sentry/react';
import { fetchEvents } from '../services/api';
import { groupEventsByTimelineDate } from '../utils/groupEventsByTimelineDate';

function useEventsData({ dates, customDateRanges, timeZone = 'America/New_York' }) {
  const [eventsByDate, setEventsByDate] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  const [allEvents, setAllEvents] = useState([]);
  const [lastUpdated, setLastUpdated] = useState(null);
  const [totalCount, setTotalCount] = useState(0);
  const [genreOptions, setGenreOptions] = useState([]);
  const [artistOptions, setArtistOptions] = useState([]);
  const [venueOptions, setVenueOptions] = useState([]);
  const [locationOptions, setLocationOptions] = useState([]);

  useEffect(() => {
    Sentry.startSpan({ name: '/api/events', op: 'fetch' }, async (span) => {
      try {
        const data = await fetchEvents();
        // Listing is authoritative on the API (`Event.not_past`). Do not filter again here —
        // a second "past" check diverges easily (field order, naive vs Z) and drops real events.
        const eventList = data.events || [];

        setEventsByDate(groupEventsByTimelineDate(eventList, dates, customDateRanges, timeZone));
        setAllEvents(eventList);
        setLastUpdated(data.meta?.last_updated || null);
        setTotalCount(data.meta?.total_count ?? eventList.length);

        setGenreOptions(
          Array.from(
            new Set(eventList.flatMap((event) => (event.genres || []).map((g) => g.name)))
          ).sort()
        );

        setArtistOptions(
          Array.from(
            new Set(
              eventList.flatMap((event) =>
                (event.artists || event.top_artists || []).map((a) => a.name)
              )
            )
          ).sort()
        );

        const venueMap = new Map();
        eventList.forEach((event) => {
          const v = event.venue;
          if (v?.name && !venueMap.has(v.name)) {
            venueMap.set(v.name, { name: v.name, subheading: v.subheading || '' });
          }
        });
        setVenueOptions(
          Array.from(venueMap.values()).sort((a, b) => a.name.localeCompare(b.name))
        );

        setLocationOptions(
          Array.from(
            new Set(
              eventList
                .filter((event) => event.venue?.location)
                .map((event) => event.venue.location)
            )
          ).sort()
        );
      } catch (error) {
        console.error('Error fetching events:', error);
      } finally {
        setIsLoaded(true);
        span.end();
      }
    });
  }, [dates, customDateRanges, timeZone]);

  return {
    isLoaded,
    allEvents,
    eventsByDate,
    genreOptions,
    artistOptions,
    venueOptions,
    locationOptions,
    lastUpdated,
    totalCount,
  };
}

export default useEventsData;
