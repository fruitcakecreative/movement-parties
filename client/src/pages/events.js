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

import { loadCityConfig } from "../services/cityConfig";

const cfg = await loadCityConfig();
const customDateRanges = cfg.customDateRanges;


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
    artist: [],
    venueType: [],
  });
  const [artistOptions, setArtistOptions] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredArtists, setFilteredArtists] = useState([]);

  const dates = Object.keys(customDateRanges);

  useEffect(() => {
    Sentry.startSpan({ name: '/api/events', op: 'fetch' }, async (span) => {
      try {
        const data = await fetchEvents();

        const eventList = data.events || [];

        const MIN_OVERLAP_MS = 3 * 60 * 60 * 1000;

const parse = (v) => (v ? new Date(v) : null);
const getStart = (e) => parse(e.formatted_start_time || e.start_time);
const getEnd = (e) => parse(e.formatted_end_time || e.end_time);

const grouped = Object.fromEntries(dates.map((d) => [d, []]));

// always include on the day it starts (normal behavior)
for (const event of eventList) {
  const startStr = event.formatted_start_time || event.start_time;
  const startDay = startStr?.slice(0, 10);
  if (grouped[startDay]) grouped[startDay].push(event);
}

// ALSO include on other days if it overlaps that day's timeline window >= 3 hours
for (const date of dates) {
  const windowStart = parse(customDateRanges[date].start);
  const windowEnd = parse(customDateRanges[date].end);

  const existing = new Set(grouped[date].map((e) => e.id));

  for (const event of eventList) {
    const startStr = event.formatted_start_time || event.start_time;
    const startDay = startStr?.slice(0, 10);
    if (startDay === date) continue; // don't "threshold-filter" its own day
    if (existing.has(event.id)) continue;

    const start = getStart(event);
    if (!start) continue;

    const endReal = getEnd(event);
    const end = endReal || windowEnd; // fallback for overlap test

    const overlapMs =
      Math.min(end.getTime(), windowEnd.getTime()) -
      Math.max(start.getTime(), windowStart.getTime());

    if (overlapMs >= MIN_OVERLAP_MS) {
      grouped[date].push(event);
      existing.add(event.id);
    }
  }
}

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
      <div className="section info-con">

        <div className="container">
          <h3 className="mini-heading">
            Relevant Info <i className="fa-solid fa-circle-info"></i>
        </h3>
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
          </div>

          <div className="container">
          <h3 className="mini-heading">
            Connect with Me <i className="fa-solid fa-heart"></i>
        </h3>

          <div className="socials flex-wrap">
            <a className="flex-center" target="_blank" rel="noreferrer" href="https://instagram.com/carlymarsh">
              <i className="highlight icon fa-brands fa-instagram"></i> Instagram
            </a>
            <a className="flex-center" target="_blank" rel="noreferrer" href="https://facebook.com/carly.marsh1">
              <i className="highlight icon fa-brands fa-square-facebook"></i> Facebook
            </a>
            <a className="flex-center" target="_blank" rel="noreferrer" href="mailto:carlypmarsh@gmail.com">
              <i className="highlight icon fa-solid fa-envelope"></i> carlypmarsh@gmail.com
            </a>
            <a
              className="flex-center"
              target="_blank"
              rel="noreferrer"
              href="https://www.linkedin.com/in/carly-marsh-a4735316a/"
            >
              <i className="highlight icon fa-brands fa-linkedin"></i> LinkedIn *sigh*
            </a>
          </div>

          </div>

          <div className="container">
            <h3 className="mini-heading">
              Support the Cause <i className="fa-solid fa-handshake-angle"></i>
          </h3>

          <p className="mb-sm">
            I made this out of pure love for the party and expect nothing in return. But, I do pay
            for the domain, server and software costs. If you'd like to show me some love or buy me
            a coffee for my efforts, I wouldn't mind <i className="fa-regular fa-heart"></i>
          </p>
          <div className="flex mb-sm">
            <a className="button" target="_blank" rel="noreferrer" href="https://venmo.com/u/CarlyMarsh7">
              Venmo
            </a>
            <a className="button" target="_blank" rel="noreferrer" href="https://cash.app/$carlymarsh7">
              CashApp
            </a>
            <a className="button" target="_blank" rel="noreferrer" href="https://paypal.me/carlypmarsh">
              PayPal
            </a>
          </div>
          <p className="">
            <span className="highlight bold">carlypmarsh@gmail.com</span>
            <br></br>
            <span className="etrans-blurb">
              e-transfer email for my fellow Canadians
              <i className="fa-brands fa-canadian-maple-leaf"></i>
            </span>
          </p>
          </div>
      </div>

    <div class="section timeline-con">

    <div class="container">

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
                  setFilterSelections({
                    genre: [],
                    cost: [],
                    age: [],
                    artist: [],
                    venueType: [],
                  })
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

            if (filterSelections.venueType && filterSelections.venueType.length > 0) {
              dayEvents = dayEvents.filter((event) =>
                filterSelections.venueType.includes(event.venue?.venue_type)
              );
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
      </div>

      {modalStack.map((modalProps, i) => (
        <ModalLayout key={i} {...modalProps} />
      ))}
    </div>
    </div>
  );
}

export default Events;
