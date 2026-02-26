import React, { useEffect, useState } from 'react';

import { fetchEvents } from '../services/api';

import { createChannels } from '../timeline/data/buildChannels';
import { createEpg } from '../timeline/data/buildEpg';

import LoadCustomScript from '../utils/loadCustomScript';

import MultiDayTimeline from '../timeline/MultiDayTimeline';
import CustomChannelItem from '../timeline/components/ChannelItem';
import ModalLayout from '../timeline/components/modals/ModalLayout';

import DateDropdown from '../timeline/components/ui/DateDropdown';
import FiltersDropdown from '../timeline/components/ui/FiltersDropdown';

import * as Sentry from '@sentry/react';

function Events({ modalStack, setModalStack }) {
  const [eventsByDate, setEventsByDate] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  const [allEvents, setAllEvents] = useState([]);
  const [selectedDate, setSelectedDate] = useState('all');
  const [genreOptions, setGenreOptions] = useState([]);
  const [filterSelections, setFilterSelections] = useState({
    genre: [],
    cost: [],
    age: [],
  });
  const [artistOptions, setArtistOptions] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredArtists, setFilteredArtists] = useState([]);

  const customDateRanges = {
    '2026-05-22': { start: '2026-05-22T15:00:00', end: '2026-05-23T06:00:00' },
    '2026-05-23': { start: '2026-05-23T10:00:00', end: '2026-05-24T12:00:00' },
    '2026-05-24': { start: '2026-05-24T10:00:00', end: '2026-05-25T12:00:00' },
    '2026-05-25': { start: '2026-05-25T09:00:00', end: '2026-05-26T13:00:00' },
    '2026-05-26': { start: '2026-05-26T06:00:00', end: '2026-05-27T09:00:00' },
    '2026-05-27': { start: '2026-05-27T11:00:00', end: '2026-05-28T03:00:00' },
  };

  const dates = Object.keys(customDateRanges);

  useEffect(() => {
    Sentry.startSpan({ name: '/api/events', op: 'fetch' }, async (span) => {
      try {
        const data = await fetchEvents();

        const grouped = {};
        const eventList = data.events || [];
        dates.forEach((date) => {
          grouped[date] = eventList.filter((event) => event.formatted_start_time?.startsWith(date));
        });
        setEventsByDate(grouped);
        setAllEvents(eventList);

        const genresFromEvents = Array.from(
          new Set(eventList.flatMap((event) => event.genres.map((g) => g.name)))
        ).sort();

        setGenreOptions(genresFromEvents);

        const allArtists = Array.from(
          new Set(
            eventList.flatMap((event) => (event.artists || event.top_artists || []).map((a) => a.name))
          )
        ).sort();

        setArtistOptions(allArtists);
      } catch (error) {
        console.error('Error fetching events:', error);
      } finally {
        setIsLoaded(true);
        span.end();
      }
    });
    // eslint-disable-next-line
  }, []);

  return (
    <div style={{ width: '100%', height: '100%', whiteSpace: 'nowrap' }}>
      <div className="heading" style={{ textAlign: 'center', margin: '20px 0' }}>
        <div className="info-con">
          <p className="bio">
            <b>
              Welcome to MovementParties.com<i className="fa-regular fa-heart"></i>
            </b>{' '}
            <br></br>
          </p>
          <p className="mini-heading">
            Relevant Info <i className="fa-solid fa-circle-info"></i>
          </p>
          <ul>
            <li>
              The site scrapes basic event data from RA. All other events + specific event info that
              isn't scrapable is manually updated by me.
              <b>
                {' '}
                So please reach out (via socials) if you don't see an event that should be included
                or if you notice any incorrect info.
              </b>
            </li>
            <li>
              The timelines are mobile-friendly, but more info is available on the desktop version
              of the site and it is a bit easier to navigate.
            </li>
            <li>
              You can click on both events on the timline and venues on the left for more
              information. I am still updating all the venue info so be patient with me there{' '}
              <i className="fa-regular fa-heart"></i>
            </li>
          </ul>

          <p className="mini-heading">
            Connect with Me <i className="fa-solid fa-heart"></i>
          </p>
          <div className="socials">
            <a target="_blank" rel="noreferrer" href="https://instagram.com/carlymarsh">
              <i className="fa-brands fa-instagram"></i> Instagram
            </a>
            <a target="_blank" rel="noreferrer" href="https://facebook.com/carly.marsh1">
              <i className="fa-brands fa-square-facebook"></i> Facebook
            </a>
            <a target="_blank" rel="noreferrer" href="mailto:carlypmarsh@gmail.com">
              <i className="fa-solid fa-envelope"></i> carlypmarsh@gmail.com
            </a>
            <a
              target="_blank"
              rel="noreferrer"
              href="https://www.linkedin.com/in/carly-marsh-a4735316a/"
            >
              <i className="fa-brands fa-linkedin"></i> LinkedIn *sigh*
            </a>
          </div>

          <p className="mini-heading">
            Support the Cause <i className="fa-solid fa-handshake-angle"></i>
          </p>
          <p className="pay-me-blurb">
            I made this out of pure love for the party and expect nothing in return. But, I do pay
            for the domain, server and software costs. If you'd like to show me some love or buy me
            a coffee for my efforts, I wouldn't mind <i className="fa-regular fa-heart"></i>
          </p>
          <div className="pay-me">
            <a target="_blank" rel="noreferrer" href="https://venmo.com/u/CarlyMarsh7">
              Venmo
            </a>
            <a target="_blank" rel="noreferrer" href="https://cash.app/$carlymarsh7">
              CashApp
            </a>
            <a target="_blank" rel="noreferrer" href="https://paypal.me/carlypmarsh">
              PayPal
            </a>
          </div>
          <p className="etrans-con">
            <span className="etrans">carlypmarsh@gmail.com</span>
            <br></br>
            <span className="etrans-blurb">
              e-transfer email for my fellow Canadians
              <i className="fa-brands fa-canadian-maple-leaf"></i>
            </span>
          </p>
          <p className="mini-heading">
            And Finally... THE PARTIES <i className="fa-solid fa-arrow-down"></i>
          </p>
        </div>
      </div>

      <DateDropdown selectedDate={selectedDate} setSelectedDate={setSelectedDate} dates={dates} />

      {!isLoaded ? (
        <p>Loading events...</p>
      ) : (
        <>
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

          {Object.entries(filterSelections).some(([_, values]) => values.length > 0) && (
            <div
              className="active-filters"
              style={{ margin: '10px 30px', display: 'flex', flexWrap: 'wrap', gap: '10px' }}
            >
              {Object.entries(filterSelections).flatMap(([category, values]) =>
                values.map((val) => {
                  const key = `${category}-${val}`.replace(/\s+/g, '-').toLowerCase();
                  return (
                    <button
                      key={key}
                      className={`filter-pill ${category}`}
                      onClick={() =>
                        setFilterSelections((prev) => ({
                          ...prev,
                          [category]: prev[category].filter((v) => v !== val),
                        }))
                      }
                    >
                      {val} <span className="x">&times;</span>
                    </button>
                  );
                })
              )}
              <button
                className="filter-reset"
                onClick={() =>
                  setFilterSelections({ genre: [], cost: [], age: [] /* add more here */ })
                }
              >
                Reset All Filters
              </button>
            </div>
          )}

          {(selectedDate === 'all' ? dates : [selectedDate]).map((date) => {
            let dayEvents = eventsByDate[date] || [];

            if (filterSelections.genre.length > 0) {
              dayEvents = dayEvents.filter((event) =>
                event.genres.some((g) => filterSelections.genre.includes(g.name))
              );
            }

            if (filterSelections.cost.length > 0) {
              dayEvents = dayEvents.filter((event) => {
                const price = parseFloat(event.ticket_price || '0');
                return filterSelections.cost.some((c) => {
                  if (c === 'Free') return price === 0;
                  if (c === 'Under $20') return price >= 0 && price <= 20;
                  if (c === 'Under $50') return price >= 0 && price <= 50;
                  return false;
                });
              });
            }

            if (filterSelections.artist && filterSelections.artist.length > 0) {
              dayEvents = dayEvents.filter((event) => {
                const allNames = [
                  ...(event.artists || []).map((a) => a.name),
                  ...(event.top_artists || []).map((a) => a.name),
                ];
                return allNames.some((name) => filterSelections.artist.includes(name));
              });
            }

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
                modalStack={modalStack}
                setModalStack={setModalStack}
                CustomChannelItem={CustomChannelItem}
              />
            );
          })}

          <LoadCustomScript />
        </>
      )}

      {modalStack.map((modalProps, i) => (
        <ModalLayout key={i} {...modalProps} />
      ))}
    </div>
  );
}

export default Events;
