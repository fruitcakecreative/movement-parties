import React from "react";
import {
  TimelineBox,
  TimelineTime,
  TimelineWrapper,
  TimelineDividers,
  TimelineDivider,
  useTimeline
} from "@nessprim/planby-pro";

const Timeline = (props) => {
  const {
    time,
    dividers,
    timelineHeight,
    timelineDividers,
    getTime,
    getTimelineProps
  } = useTimeline(props);

  const {
    isToday,
    isBaseTimeFormat,
    isCurrentTime,
    isTimelineVisible,
    hourWidth
  } = props;

  const renderDividers = (isNewDay) =>
    dividers.map((_, index) => (
      <TimelineDivider
        key={index}
        isNewDay={isNewDay}
        width={hourWidth / timelineDividers}
        left={index * (hourWidth / timelineDividers)}
      />
    ));

  return (
    <TimelineWrapper {...getTimelineProps()} className="timeline-wrapper">
      {time.map((item, index) => {
        const { isNewDay, time } = getTime(item);
        const formatted = time.replace(":00", "").toLowerCase();

        const position = { left: hourWidth * index, width: hourWidth };

        if (!isTimelineVisible(position)) return null;

        return (
          <TimelineBox
            className="timeline-box"
            key={index}
            isToday={isToday}
            isCurrentTime={isCurrentTime}
            timelineHeight={timelineHeight}
            {...position}
          >
            <TimelineTime
              className="timeline-time"
              data-time={formatted}
              data-index={index}
              isNewDay={isNewDay}
              isBaseTimeFormat={isBaseTimeFormat}
            >
            {isNewDay ? "12am" : formatted}

            </TimelineTime>
            <TimelineDividers>
              {renderDividers(isNewDay)}
            </TimelineDividers>
          </TimelineBox>
        );
      })}
    </TimelineWrapper>
  );
};

export default Timeline;
