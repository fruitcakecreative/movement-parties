import React, { useMemo } from 'react';
import DetailsShell from '../templates/DetailsShell';
import EventDetailsContent from './EventDetailsContent';

function EventDetailsShell({
  eventId,
  allEvents,
  onClose,
  mainScrollRef,
  desktopScrollRef,
  openVenue,
}) {
  const selectedEvent = useMemo(() => {
    return (allEvents || []).find(
      (event) => String(event.id) === String(eventId)
    );
  }, [allEvents, eventId]);

  return (
    <DetailsShell
      isOpen={!!eventId && !!selectedEvent}
      mainScrollRef={mainScrollRef}
      desktopScrollRef={desktopScrollRef}
    >
    <EventDetailsContent
      event={selectedEvent}
      onClose={onClose}
      openVenue={openVenue}
      />
    </DetailsShell>
  );
}

export default EventDetailsShell;
