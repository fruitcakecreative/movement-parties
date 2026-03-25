import React, { useEffect, useMemo, useRef, useState } from 'react';
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
import { formatFestivalDayLong, getActiveTimelineDateKeys } from '../utils/timelineSchedule';

const cfg = await loadCityConfig();
const customDateRanges = cfg.customDateRanges;
const timelineTimeZone =
  cfg.timezone ||
  (process.env.REACT_APP_CITY_KEY === 'movement' ? 'America/Detroit' : 'America/New_York');

function Events() {
  // Recompute active festival days after each window end (e.g. Wed 10am) without a full reload.
  const [scheduleTick, setScheduleTick] = useState(0);
  useEffect(() => {
    const id = setInterval(() => setScheduleTick((n) => n + 1), 60_000);
    const onFocus = () => setScheduleTick((n) => n + 1);
    window.addEventListener('focus', onFocus);
    return () => {
      clearInterval(id);
      window.removeEventListener('focus', onFocus);
    };
  }, []);

  // customDateRanges + timelineTimeZone come from loadCityConfig (module scope); scheduleTick forces recompute when windows end.
  const activeDates = useMemo(() => {
    void scheduleTick;
    return getActiveTimelineDateKeys(customDateRanges, timelineTimeZone);
  }, [scheduleTick]);
  const [searchParams, setSearchParams] = useSearchParams();
  const selectedEventId = searchParams.get('eventId');
  const selectedVenueId = searchParams.get('venueId');
  const fromEventId = searchParams.get('fromEvent');
  const fromVenueId = searchParams.get('fromVenue');
  const mainScrollRef = useRef(null);
  const desktopScrollRef = useRef(0);

  const openEvent = (eventId, fromVenue) => {
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
    next.delete('fromEvent');
    next.set('eventId', eventId);
    if (fromVenue) next.set('fromVenue', fromVenue);
    setSearchParams(next, { preventScrollReset: true });
  };

  const closeEvent = () => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }

    const next = new URLSearchParams(searchParams);
    next.delete('eventId');
    next.delete('fromVenue');
    setSearchParams(next, { preventScrollReset: true });
  };

  const goBackToEvent = () => {
    if (!fromEventId) return;
    const next = new URLSearchParams(searchParams);
    next.delete('venueId');
    next.delete('fromEvent');
    next.set('eventId', fromEventId);
    setSearchParams(next, { preventScrollReset: true });
  };

  const goBackToVenue = () => {
    if (!fromVenueId) return;
    const next = new URLSearchParams(searchParams);
    next.delete('eventId');
    next.delete('fromVenue');
    next.set('venueId', fromVenueId);
    setSearchParams(next, { preventScrollReset: true });
  };

  const openVenue = (venueId, fromEvent) => {
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
    next.delete('fromVenue');
    next.set('venueId', venueId);
    if (fromEvent) next.set('fromEvent', fromEvent);
    setSearchParams(next, { preventScrollReset: true });
  };

  const closeVenue = () => {
    const isMobile = window.innerWidth < 768;

    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }

    const next = new URLSearchParams(searchParams);
    next.delete('venueId');
    next.delete('fromEvent');
    setSearchParams(next, { preventScrollReset: true });
  };

  const {
    isLoaded,
    allEvents,
    eventsByDate,
    genreOptions,
    artistOptions,
    venueOptions,
    locationOptions,
    lastUpdated,
    totalCount,
  } = useEventsData({ dates: activeDates, customDateRanges });

  const {
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
  } = useEventFilters({ eventsByDate, activeDates });

  return (
    <div className={`events-page ${(selectedEventId || selectedVenueId) ? 'has-selected-event' : ''}`}>
      <div ref={mainScrollRef} className="events-page__main">
        <MainHeader />
        <EventsIntro lastUpdated={lastUpdated} totalCount={totalCount} isLoaded={isLoaded} />

        <div className="section timeline-con">
          <div className="container">
            <EventsToolbar
              selectedDate={selectedDate}
              setSelectedDate={setSelectedDate}
              dates={activeDates}
              timeZone={timelineTimeZone}
              isLoaded={isLoaded}
              filterSelections={filterSelections}
              setFilterSelections={setFilterSelections}
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
                {(selectedDate === 'all' ? activeDates : [selectedDate]).map((date) => {
                  const dayEvents = getFilteredEventsForDate(date);
                  const epg = createEpg(dayEvents);
                  const channels = createChannels(epg);

                  if (!epg.length) {
                    return (
                      <div key={date} style={{ textAlign: 'center', margin: '40px 0' }}>
                        <p style={{ fontStyle: 'italic', color: '#aaa' }}>
                          No events match your filters for{' '}
                          {formatFestivalDayLong(date, timelineTimeZone)}
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
                      timeZone={timelineTimeZone}
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
        fromVenueId={fromVenueId}
        onBackToVenue={goBackToVenue}
      />
      <VenueDetailsShell
        venueId={selectedVenueId}
        allEvents={allEvents}
        onClose={closeVenue}
        mainScrollRef={mainScrollRef}
        desktopScrollRef={desktopScrollRef}
        openEvent={openEvent}
        fromEventId={fromEventId}
        onBackToEvent={goBackToEvent}
      />
    </div>
  );
}

export default Events;
