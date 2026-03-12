import { useMemo, useState } from 'react';

const defaultFilters = {
  genre: [],
  cost: [],
  age: [],
  artist: [],
  venueType: [],
};

function useEventFilters({ eventsByDate }) {
  const [selectedDate, setSelectedDate] = useState('all');
  const [filterSelections, setFilterSelections] = useState(defaultFilters);
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredArtists, setFilteredArtists] = useState([]);

  const hasActiveFilters = useMemo(
    () => Object.values(filterSelections).some((values) => values.length > 0),
    [filterSelections]
  );

  const resetFilters = () => setFilterSelections(defaultFilters);

  const getFilteredEventsForDate = (date) => {
    let dayEvents = eventsByDate[date] || [];

    if (filterSelections.genre.length > 0) {
      dayEvents = dayEvents.filter((event) =>
        (event.genres || []).some((g) => filterSelections.genre.includes(g.name))
      );
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
    getFilteredEventsForDate,
    hasActiveFilters,
    resetFilters,
  };
}

export default useEventFilters;
