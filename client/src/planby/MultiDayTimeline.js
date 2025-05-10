import { useEffect } from "react";
import { useEpg, Epg, Layout } from "@nessprim/planby-pro";
import Timeline from "./components/Timeline";
import ChannelItem from "./components/ChannelItem";
import ProgramItem from "./components/ProgramItem";

const MultiDayTimeline = ({ date, epg, channels, startDate, endDate, allEvents, modalStack, setModalStack }) => {
  const isMobile = window.innerWidth < 768;

  const hourWidth = isMobile ? 35 : 65;
  const itemHeight = isMobile ? 60 : 90;
  const sidebarWidth = isMobile ? 65 : 120;

  const start = new Date(startDate);
  const end = new Date(endDate);
  const hours = Math.round((end - start) / (1000 * 60 * 60));
  const dayWidth = hourWidth * hours;
  const hourClass = `hours-${hours}`;

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
  });

  useEffect(() => {
    const timeout = setTimeout(() => {
      const cornerWrapper = document.querySelector(`.corner-wrapper-${date}`);
      const cornerBox = cornerWrapper?.querySelector(".planby-corner-box");
      if (cornerBox) {
        const existing = cornerBox.querySelector(`.corner-label-${date}`);
        if (!existing) {
          const label = document.createElement("div");
          label.className = `my-custom-label corner-label-${date}`;
          label.innerText = new Date(`${date}T12:00:00`).toLocaleDateString("en-US", {
            weekday: "short",
            month: "short",
            day: "numeric",
          });
          label.style.padding = "5px";
          label.style.fontWeight = "bold";
          cornerBox.appendChild(label);
        }
      }
    }, 300);

    return () => clearTimeout(timeout);
  }, [date]);

  useEffect(() => {
    if (epg.length === 0) return;

    const firstStart = new Date(
      Math.min(...epg.map((e) => new Date(e.since)))
    );

    const timelineContainer = document.querySelector("#planby-layout-scrollbox");

    if (timelineContainer) {
      const hoursFromStart = (firstStart - new Date(startDate)) / (1000 * 60 * 60);
      const scrollX = hoursFromStart * hourWidth;
      timelineContainer.scrollTo({ left: scrollX, behavior: "smooth" });
    }
  }, [epg, startDate, hourWidth]);


  return (
    <div
      className={`timeline-day ${hourClass} corner-wrapper-${date}`}
      style={{ marginBottom: "15px" }}>
      <Epg {...getEpgProps()}>
        <Layout
          {...getLayoutProps()}
          renderTimeline={(props) => <Timeline {...props} />}
          renderChannel={({ channel }) => (
            <ChannelItem
              channel={channel}
              allEvents={allEvents}
              modalStack={modalStack}
              setModalStack={setModalStack}
            />
          )}
          renderProgram={({ program, ...rest }) => (
            <ProgramItem
              key={program.id}
              program={{
                ...program,
                hourWidth,
                timelineStart: startDate,
              }}
              scrollLeft={scrollX}
              {...rest}
            />
          )}
        />
      </Epg>
    </div>
  );
};

export default MultiDayTimeline;
