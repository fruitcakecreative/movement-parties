import React from 'react';
import { useNavigate } from 'react-router-dom';
import DateDropdown from '../../timeline/components/ui/DateDropdown';
import FiltersDropdown from '../../timeline/components/ui/FiltersDropdown';
import SheTheyForwardToggle from './SheTheyForwardToggle';
import JustAddedToggle from './JustAddedToggle';
import FriendsTimelineToggle from './FriendsTimelineToggle';
import { showSheTheyForwardFilter } from '../../utils/cityFeatureFlags';
import { trackPlausible } from '../../utils/plausible';
import { useUserEvents } from '../../context/UserEventsContext';

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
  eventSearchQuery,
  setEventSearchQuery,
  sheTheyOver50LineupStats = null,
}) {
  const navigate = useNavigate();
  const { isAuthenticated } = useUserEvents();

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

      <FriendsTimelineToggle
        enabled={!!filterSelections.friendsTimelineOnly}
        onChange={(next) => {
          if (next && !isAuthenticated) {
            navigate('/login');
            return;
          }
          trackPlausible('Friends Timeline Filter', { state: next ? 'on' : 'off' });
          setFilterSelections((prev) => ({ ...prev, friendsTimelineOnly: next }));
        }}
      />

      <DateDropdown
        selectedDate={selectedDate}
        setSelectedDate={setSelectedDate}
        dates={dates}
        timeZone={timeZone}
      />

      {isLoaded && (
        <div className="events-toolbar-filters-cluster">
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
          <div className="events-toolbar-event-search">
            <input
              id="events-page-event-search"
              type="search"
              className="events-toolbar-event-search__input"
              placeholder="Search events…"
              value={eventSearchQuery}
              onChange={(e) => setEventSearchQuery(e.target.value)}
              autoComplete="off"
              aria-label="Search events by name, venue, or artist"
            />
          </div>
        </div>
      )}
    </>
  );
}

export default EventsToolbar;
