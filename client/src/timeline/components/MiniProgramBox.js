import React from 'react';
import EventCard from '../../components/EventCard';

/** Profile / friend profile: optional compact density (e.g. interested grid). */
const MiniProgramBox = ({ event, onClick, density = 'default' }) => {
  return (
    <EventCard
      event={event}
      onClick={onClick}
      showVenueName
      showArtists={false}
      density={density}
    />
  );
};

export default MiniProgramBox;
