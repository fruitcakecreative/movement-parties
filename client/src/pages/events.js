import React, { useRef } from 'react';
import { useSearchParams } from 'react-router-dom';

import MainHeader from '../components/MainHeader';

import EventsIntro from '../components/events/EventsIntro';
import EventsToolbar from '../components/events/EventsToolbar';
import ActiveFilters from '../components/events/ActiveFilters';

import EventDetailsShell from '../components/events/EventDetailsShell';
import VenueDetailsShell from '../components/venues/VenueDetailsShell';

import MultiDayTimeline from '../timeline/MultiDayTimeline';
import CustomChannelItem from '../timeline/components/ChannelItem';
import LoadCustomScript from '../utils/loadCustomScript';

import { loadCityConfig } from "../services/cityConfig";
import { createChannels } from '../timeline/data/buildChannels';
import { createEpg } from '../timeline/data/buildEpg';

import useEventsData from '../hooks/useEventsData';
import useEventFilters from '../hooks/useEventFilters';

const cfg = await loadCityConfig();
const customDateRanges = cfg.customDateRanges;
const dates = Object.keys(customDateRanges);


function Events() {
  const [searchParams, setSearchParams] = useSearchParams();
  const selectedEventId = searchParams.get('eventId');
  const selectedVenueId = searchParams.get('venueId');
  const mainScrollRef = useRef(null);
  const desktopScrollRef = useRef(0);

  const openEvent = (eventId) => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile) {
      if ((selectedEventId || selectedVenueId) && mainScrollRef.current) {
        desktopScrollRef.current = mainScrollRef.current.scrollTop;
      } else {
        desktopScrollRef.current = window.scrollY;
      }
    }

    const next = new URLSearchParams(searchParams);
    next.delete('venueId');
    next.set('eventId', eventId);
    setSearchParams(next, { preventScrollReset: true });
  };

  const closeEvent = () => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }

    const next = new URLSearchParams(searchParams);
    next.delete('eventId');
    setSearchParams(next, { preventScrollReset: true });
  };

  const openVenue = (venueId) => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile) {
      if ((selectedEventId || selectedVenueId) && mainScrollRef.current) {
        desktopScrollRef.current = mainScrollRef.current.scrollTop;
      } else {
        desktopScrollRef.current = window.scrollY;
      }
    }

    const next = new URLSearchParams(searchParams);
    next.delete('eventId');
    next.set('venueId', venueId);
    setSearchParams(next, { preventScrollReset: true });
  };

  const closeVenue = () => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }

    const next = new URLSearchParams(searchParams);
    next.delete('venueId');
    setSearchParams(next, { preventScrollReset: true });
  };

  const {
    isLoaded,
    allEvents,
    eventsByDate,
    genreOptions,
    artistOptions,
  } = useEventsData({ dates, customDateRanges });

  const {
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
  } = useEventFilters({ eventsByDate });

  return (
    <div className={`events-page ${(selectedEventId || selectedVenueId) ? 'has-selected-event' : ''}`}>
      <div ref={mainScrollRef} className="events-page__main">
        <MainHeader />
        <EventsIntro />

        <div className="section timeline-con">
          <div className="container">
            <EventsToolbar
              selectedDate={selectedDate}
              setSelectedDate={setSelectedDate}
              dates={dates}
              isLoaded={isLoaded}
              filterSelections={filterSelections}
              setFilterSelections={setFilterSelections}
              genreOptions={genreOptions}
              artistOptions={artistOptions}
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
              filteredArtists={filteredArtists}
              setFilteredArtists={setFilteredArtists}
            />

            {!isLoaded ? (
              <p>Loading events...</p>
            ) : (
              <>
                <ActiveFilters
                  filterSelections={filterSelections}
                  setFilterSelections={setFilterSelections}
                  hasActiveFilters={hasActiveFilters}
                  resetFilters={resetFilters}
                />
                {(selectedDate === 'all' ? dates : [selectedDate]).map((date) => {
                  const dayEvents = getFilteredEventsForDate(date);
                  const epg = createEpg(dayEvents);
                  const channels = createChannels(epg);

                  if (!epg.length) {
                    return (
                      <div key={date} style={{ textAlign: 'center', margin: '40px 0' }}>
                        <p style={{ fontStyle: 'italic', color: '#aaa' }}>
                          No events match your filters for{' '}
                          {new Date(`${date}T12:00:00`).toLocaleDateString('en-US', {
                            weekday: 'long',
                            month: 'short',
                            day: 'numeric',
                          })}
                          .
                        </p>
                      </div>
                    );
                  }

                  return (
                    <MultiDayTimeline
                      key={date}
                      date={date}
                      epg={epg}
                      channels={channels}
                      startDate={customDateRanges[date].start}
                      endDate={customDateRanges[date].end}
                      allEvents={allEvents}
                      selectedEventId={selectedEventId}
                      openEvent={openEvent}
                      openVenue={openVenue}
                      CustomChannelItem={CustomChannelItem}
                    />
                  );
                })}

                <LoadCustomScript />
              </>
            )}
          </div>
        </div>
      </div>
      <EventDetailsShell
        eventId={selectedEventId}
        allEvents={allEvents}
        onClose={closeEvent}
        mainScrollRef={mainScrollRef}
        desktopScrollRef={desktopScrollRef}
        openVenue={openVenue}
      />
      <VenueDetailsShell
        venueId={selectedVenueId}
        allEvents={allEvents}
        onClose={closeVenue}
        mainScrollRef={mainScrollRef}
        desktopScrollRef={desktopScrollRef}
        openEvent={openEvent}
      />
    </div>
  );
}

export default Events;
