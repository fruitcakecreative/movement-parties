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
  venueOptions,
  locationOptions,
  searchQuery,
  setSearchQuery,
  filteredArtists,
  setFilteredArtists,
  venueSearchQuery,
  setVenueSearchQuery,
  filteredVenues,
  setFilteredVenues,
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
          venueOptions={venueOptions}
          locationOptions={locationOptions}
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          filteredArtists={filteredArtists}
          setFilteredArtists={setFilteredArtists}
          venueSearchQuery={venueSearchQuery}
          setVenueSearchQuery={setVenueSearchQuery}
          filteredVenues={filteredVenues}
          setFilteredVenues={setFilteredVenues}
        />
      )}
    </>
  );
}

export default EventsToolbar;
