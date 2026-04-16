import React from 'react';
import DateDropdown from '../../timeline/components/ui/DateDropdown';
import FiltersDropdown from '../../timeline/components/ui/FiltersDropdown';
import SheTheyForwardToggle from './SheTheyForwardToggle';
import { showSheTheyForwardFilter } from '../../utils/cityFeatureFlags';

function EventsToolbar({
  selectedDate,
  setSelectedDate,
  dates,
  timeZone,
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
      {showSheTheyForwardFilter && (
        <SheTheyForwardToggle
          enabled={!!filterSelections.sheTheyForwardTimeline}
          onEnabledChange={(next) =>
            setFilterSelections((prev) => ({
              ...prev,
              sheTheyForwardTimeline: next,
              ...(next ? {} : { sheTheyOver50Lineup: false }),
            }))
          }
          over50Only={!!filterSelections.sheTheyOver50Lineup}
          onOver50Change={(next) =>
            setFilterSelections((prev) => ({ ...prev, sheTheyOver50Lineup: next }))
          }
        />
      )}

      <DateDropdown
        selectedDate={selectedDate}
        setSelectedDate={setSelectedDate}
        dates={dates}
        timeZone={timeZone}
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
