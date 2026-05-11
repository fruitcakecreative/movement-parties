import React from 'react';
import EventCard from '../../components/EventCard';

const MiniProgramBox = ({ event, onClick }) => {
  return <EventCard event={event} onClick={onClick} showVenueName showArtists={false} />;
};

export default MiniProgramBox;
