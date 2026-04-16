import React from 'react';
import DateDropdown from '../../timeline/components/ui/DateDropdown';
import FiltersDropdown from '../../timeline/components/ui/FiltersDropdown';
import SheTheyForwardToggle from './SheTheyForwardToggle';
import JustAddedToggle from './JustAddedToggle';
import { showSheTheyForwardFilter } from '../../utils/cityFeatureFlags';
import { trackPlausible } from '../../utils/plausible';

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
  sheTheyOver50LineupStats = null,
}) {
  return (
    <>
      {showSheTheyForwardFilter && (
        <SheTheyForwardToggle
          over50LineupStats={sheTheyOver50LineupStats}
          enabled={!!filterSelections.sheTheyForwardTimeline}
          onEnabledChange={(next) => {
            trackPlausible('No Boys Club', { state: next ? 'on' : 'off' });
            setFilterSelections((prev) => ({
              ...prev,
              sheTheyForwardTimeline: next,
              ...(next ? {} : { sheTheyOver50Lineup: false }),
            }));
          }}
          over50Only={!!filterSelections.sheTheyOver50Lineup}
          onOver50Change={(next) => {
            trackPlausible('She They 50 Percent Lineup', { state: next ? 'on' : 'off' });
            setFilterSelections((prev) => ({ ...prev, sheTheyOver50Lineup: next }));
          }}
        />
      )}

      <JustAddedToggle
        enabled={!!filterSelections.addedLastWeekOnly}
        onChange={(next) => {
          trackPlausible('Just Added Filter', { state: next ? 'on' : 'off' });
          setFilterSelections((prev) => ({ ...prev, addedLastWeekOnly: next }));
        }}
      />

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
