import { useEffect, useMemo, useState } from 'react';
import { expandGenreSelections, eventMatchesGenreFilter } from '../utils/genreGroups';
import { showSheTheyForwardFilter } from '../utils/cityFeatureFlags';
import {
  readSheTheyForwardEnabled,
  readSheTheyOver50LineupEnabled,
  syncSheTheyForwardState,
  syncSheTheyOver50State,
} from '../utils/sheTheyTheme';
import { sheTheyForwardLineupPercent } from '../utils/pronounDisplay';
import { eventCreatedInLastWeek } from '../utils/eventRecency';

const defaultFilters = {
  genre: [],
  cost: [],
  age: [],
  artist: [],
  venue: [],
  location: [],
  venueType: [],
  /** When true, timeline / venue cards omit he-presenting artists (he/him, duo/trio/group, he/they). */
  sheTheyForwardTimeline: false,
  /** When true (and she-they mode on), list only events whose lineup is at least 50% she/they-forward. */
  sheTheyOver50Lineup: false,
  /** When true, only events whose `created_at` is within the last 7 days. */
  addedLastWeekOnly: false,
};

function useEventFilters({ eventsByDate, activeDates = [] }) {
  const [selectedDate, setSelectedDate] = useState('all');
  const [filterSelections, setFilterSelections] = useState(() => {
    const mainOn = showSheTheyForwardFilter && readSheTheyForwardEnabled();
    return {
      ...defaultFilters,
      sheTheyForwardTimeline: mainOn,
      sheTheyOver50Lineup: mainOn && readSheTheyOver50LineupEnabled(),
    };
  });
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredArtists, setFilteredArtists] = useState([]);
  const [venueSearchQuery, setVenueSearchQuery] = useState('');
  const [filteredVenues, setFilteredVenues] = useState([]);

  const hasActiveFilters = useMemo(() => {
    const arrayKeys = Object.entries(filterSelections).filter(
      ([k]) =>
        k !== 'sheTheyForwardTimeline' &&
        k !== 'sheTheyOver50Lineup' &&
        k !== 'addedLastWeekOnly'
    );
    const arraysActive = arrayKeys.some(([, v]) => Array.isArray(v) && v.length > 0);
    return (
      arraysActive ||
      filterSelections.addedLastWeekOnly === true ||
      filterSelections.sheTheyForwardTimeline === true ||
      filterSelections.sheTheyOver50Lineup === true
    );
  }, [filterSelections]);

  const resetFilters = () =>
    setFilterSelections((prev) => ({
      ...defaultFilters,
      sheTheyForwardTimeline: prev.sheTheyForwardTimeline,
      sheTheyOver50Lineup: false,
      addedLastWeekOnly: false,
    }));

  useEffect(() => {
    if (selectedDate === 'all') return;
    if (!activeDates?.includes(selectedDate)) {
      setSelectedDate('all');
    }
  }, [activeDates, selectedDate]);

  useEffect(() => {
    if (!showSheTheyForwardFilter) return;
    syncSheTheyForwardState(filterSelections.sheTheyForwardTimeline);
  }, [filterSelections.sheTheyForwardTimeline]);

  useEffect(() => {
    if (!showSheTheyForwardFilter) return;
    if (!filterSelections.sheTheyForwardTimeline) return;
    syncSheTheyOver50State(filterSelections.sheTheyOver50Lineup);
  }, [filterSelections.sheTheyOver50Lineup, filterSelections.sheTheyForwardTimeline]);

  useEffect(() => {
    if (!filterSelections.sheTheyForwardTimeline && filterSelections.sheTheyOver50Lineup) {
      setFilterSelections((prev) => ({ ...prev, sheTheyOver50Lineup: false }));
    }
  }, [filterSelections.sheTheyForwardTimeline, filterSelections.sheTheyOver50Lineup]);

  const getFilteredEventsForDate = (date) => {
    let dayEvents = eventsByDate[date] || [];

    if (filterSelections.genre.length > 0) {
      const expanded = expandGenreSelections(filterSelections.genre);
      dayEvents = dayEvents.filter((event) => eventMatchesGenreFilter(event, expanded));
    }

    if (filterSelections.cost.length > 0) {
      dayEvents = dayEvents.filter((event) => {
        const hasPrice =
          event.ticket_price !== null &&
          event.ticket_price !== undefined &&
          event.ticket_price !== '';

        const price = hasPrice ? parseFloat(event.ticket_price) : null;

        return filterSelections.cost.some((c) => {
          if (c === 'Free') return price === 0;
          if (c === 'Under $20') return price !== null && price <= 20;
          if (c === 'Under $50') return price !== null && price <= 50;
          return false;
        });
      });
    }

    if (filterSelections.artist.length > 0) {
      dayEvents = dayEvents.filter((event) => {
        const allNames = [
          ...(event.artists || []).map((a) => a.name),
          ...(event.top_artists || []).map((a) => a.name),
        ];
        return allNames.some((name) => filterSelections.artist.includes(name));
      });
    }

    if (filterSelections.venue.length > 0) {
      dayEvents = dayEvents.filter((event) =>
        filterSelections.venue.includes(event.venue?.name)
      );
    }

    if (filterSelections.location.length > 0) {
      dayEvents = dayEvents.filter((event) =>
        filterSelections.location.includes(event.venue?.location)
      );
    }

    if (filterSelections.venueType.length > 0) {
      dayEvents = dayEvents.filter((event) =>
        filterSelections.venueType.includes(event.venue?.venue_type)
      );
    }

    if (filterSelections.age.length > 0) {
      dayEvents = dayEvents.filter((event) => {
        const rawAge = (event.age || event.venue?.age || '')
          .toString()
          .trim()
          .toLowerCase();

        const normalizedAge =
          rawAge === 'all ages' || rawAge === 'allages'
            ? 'All Ages'
            : rawAge.includes('21')
            ? '21+'
            : rawAge.includes('18')
            ? '18+'
            : null;

        return normalizedAge && filterSelections.age.includes(normalizedAge);
      });
    }

    if (
      filterSelections.sheTheyForwardTimeline &&
      filterSelections.sheTheyOver50Lineup
    ) {
      dayEvents = dayEvents.filter((event) => {
        const pct = sheTheyForwardLineupPercent(event.artists || []);
        return pct != null && pct >= 50;
      });
    }

    if (filterSelections.addedLastWeekOnly) {
      dayEvents = dayEvents.filter((event) => eventCreatedInLastWeek(event));
    }

    return dayEvents;
  };

  return {
    selectedDate,
    setSelectedDate,
    filterSelections,
    setFilterSelections,
    searchQuery,
    setSearchQuery,
    filteredArtists,
    setFilteredArtists,
    venueSearchQuery,
    setVenueSearchQuery,
    filteredVenues,
    setFilteredVenues,
    getFilteredEventsForDate,
    hasActiveFilters,
    resetFilters,
  };
}

export default useEventFilters;
