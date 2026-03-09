import React from 'react';
import DateDropdown from '../../timeline/components/ui/DateDropdown';
import FiltersDropdown from '../../timeline/components/ui/FiltersDropdown';

function EventsToolbar({
  selectedDate,
  setSelectedDate,
  dates,
  isLoaded,
  filterSelections,
  setFilterSelections,
  genreOptions,
  artistOptions,
  searchQuery,
  setSearchQuery,
  filteredArtists,
  setFilteredArtists,
}) {
  return (
    <>
      <DateDropdown
        selectedDate={selectedDate}
        setSelectedDate={setSelectedDate}
        dates={dates}
      />

      {isLoaded && (
        <FiltersDropdown
          selected={filterSelections}
          setSelected={setFilterSelections}
          genreOptions={genreOptions}
          artistOptions={artistOptions}
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          filteredArtists={filteredArtists}
          setFilteredArtists={setFilteredArtists}
        />
      )}
    </>
  );
}

export default EventsToolbar;
