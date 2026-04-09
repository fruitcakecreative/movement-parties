import { useEffect, useMemo, useRef, useState } from 'react';
import { useEpg, Epg, Layout } from '@nessprim/planby-pro';
import { formatFestivalDayShort } from '../utils/timelineSchedule';
import Timeline from './components/Timeline';
import ChannelItem from './components/ChannelItem';
import ProgramItem from './components/ProgramItem';

/** Planby's isToday matches calendar day of startDate. Our ranges cross midnight (e.g. noon → next day 10am), so after midnight "now" is no longer the same calendar day as start — the current-time line disappears. Treat as "today" whenever now is inside [startDate, endDate]. */
function useNowWithinRange(startDate, endDate) {
  const [clock, setClock] = useState(() => Date.now());

  useEffect(() => {
    const id = setInterval(() => setClock(Date.now()), 60_000);
    const onFocus = () => setClock(Date.now());
    window.addEventListener('focus', onFocus);
    return () => {
      clearInterval(id);
      window.removeEventListener('focus', onFocus);
    };
  }, []);

  return useMemo(() => {
    const now = new Date(clock);
    const start = new Date(startDate);
    const end = new Date(endDate);
    return now >= start && now <= end;
  }, [clock, startDate, endDate]);
}

const MultiDayTimeline = ({
  date,
  epg,
  channels,
  startDate,
  endDate,
  allEvents,
  openEvent,
  openVenue,
  timeZone = 'America/New_York',
  sheTheyForwardTimeline = false,
}) => {
  const [dimensions, setDimensions] = useState({
    isMobile: window.innerWidth < 768,
    hourWidth: window.innerWidth < 768 ? 35 : 65,
    itemHeight: window.innerWidth < 768 ? 75 : 90,
    sidebarWidth: window.innerWidth < 768 ? 75 : 120,
  });

  useEffect(() => {
    const handleResize = () => {
      const isMobile = window.innerWidth < 768;
      setDimensions({
        isMobile,
        hourWidth: isMobile ? 35 : 65,
        itemHeight: isMobile ? 75 : 90,
        sidebarWidth: isMobile ? 75 : 120,
      });
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const { hourWidth, itemHeight, sidebarWidth } = dimensions;

  const start = new Date(startDate);
  const end = new Date(endDate);
  const hours = Math.max(1, Math.ceil((end - start) / (1000 * 60 * 60)));
  const dayWidth = hourWidth * hours;
  const hourClass = `hours-${hours}`;

  const nowWithinWindow = useNowWithinRange(startDate, endDate);

  const { getEpgProps, getLayoutProps, scrollX } = useEpg({
    channels,
    epg,
    startDate,
    endDate,
    dayWidth,
    itemHeight,
    sidebarWidth,
    isBaseTimeFormat: true,
    timelineDividers: 1,
    isLine: true,
    // Library default is false when omitted — line never draws. Gate on our window, not calendar day.
    isCurrentTime: nowWithinWindow,
  });

  const hasAutoScrolledRef = useRef(false);

  /** Pixels left of viewport edge where we want the current-time line after initial scroll. */
  const NOW_LINE_INSET_PX = 72;

  useEffect(() => {
    const timeout = setTimeout(() => {
      const cornerWrapper = document.querySelector(`.corner-wrapper-${date}`);
      const cornerBox = cornerWrapper?.querySelector('.planby-corner-box');
      if (cornerBox) {
        const existing = cornerBox.querySelector(`.corner-label-${date}`);
        if (!existing) {
          const label = document.createElement('div');
          label.className = `corner-label corner-label-${date}`;
          label.innerText = formatFestivalDayShort(date, timeZone);
          label.style.padding = '5px';
          label.style.fontWeight = 'bold';
          cornerBox.appendChild(label);
        }
      }
    }, 300);

    return () => clearTimeout(timeout);
  }, [date, timeZone]);

  useEffect(() => {
    if (epg.length === 0) return;
    if (hasAutoScrolledRef.current) return;

    const cornerWrapper = document.querySelector(`.corner-wrapper-${date}`);
    const timelineContainer = cornerWrapper?.querySelector('#planby-layout-scrollbox');
    if (!timelineContainer) return;

    const startMs = new Date(startDate).getTime();
    const endMs = new Date(endDate).getTime();
    const nowMs = Date.now();
    const inWindow = nowMs >= startMs && nowMs <= endMs;

    let nextScrollX;
    if (inWindow) {
      const hoursFromStart = (nowMs - startMs) / (1000 * 60 * 60);
      const xNow = hoursFromStart * hourWidth;
      const inset = Math.min(NOW_LINE_INSET_PX, Math.max(0, timelineContainer.clientWidth * 0.12));
      nextScrollX = xNow - inset;
    } else {
      const firstStart = new Date(Math.min(...epg.map((e) => new Date(e.since))));
      const hoursFromStart = (firstStart - startMs) / (1000 * 60 * 60);
      nextScrollX = hoursFromStart * hourWidth;
    }

    const maxScroll = Math.max(0, timelineContainer.scrollWidth - timelineContainer.clientWidth);
    const clamped = Math.max(0, Math.min(nextScrollX, maxScroll));
    timelineContainer.scrollTo({ left: clamped, behavior: 'auto' });
    hasAutoScrolledRef.current = true;
  }, [epg, startDate, endDate, hourWidth, date]);

  useEffect(() => {
    hasAutoScrolledRef.current = false;
  }, [date, startDate, endDate]);


  return (
    <div
      className={`timeline-day ${hourClass} corner-wrapper-${date}`}
      style={{ marginBottom: '15px' }}
    >
      <Epg {...getEpgProps()}>
        <Layout
          {...getLayoutProps()}
          // useEpg sets isToday from date-fns isToday(calendar day) — wrong after midnight on a noon→next-day span.
          isToday={nowWithinWindow}
          isCurrentTime={nowWithinWindow}
          renderTimeline={(timelineProps) => (
            <Timeline {...timelineProps} isToday={nowWithinWindow} isCurrentTime={nowWithinWindow} />
          )}
          renderChannel={({ channel }) => (
            <ChannelItem
              key={channel.uuid || channel.name}
              channel={channel}
              openVenue={openVenue}
            />
          )}
          renderProgram={({ program, ...rest }) => (
            <ProgramItem
              key={`${program.id || program.title || Math.random()}`}
              program={{
                ...program,
                hourWidth,
                timelineStart: startDate,
              }}
              scrollLeft={scrollX}
              openEvent={openEvent}
              sheTheyForwardTimeline={sheTheyForwardTimeline}
              {...rest}
            />
          )}
        />
      </Epg>
    </div>
  );
};

export default MultiDayTimeline;
