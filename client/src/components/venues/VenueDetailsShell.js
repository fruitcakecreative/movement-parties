import React, { useMemo } from 'react';
import DetailsShell from '../templates/DetailsShell';
import VenueDetailsContent from './VenueDetailsContent';

function VenueDetailsShell({
  venueId,
  allEvents,
  onClose,
  mainScrollRef,
  desktopScrollRef,
  openEvent,
  fromEventId,
  onBackToEvent,
}) {
  const venueEvents = useMemo(() => {
    return (allEvents || []).filter(
      (event) => String(event.venue?.id) === String(venueId)
    );
  }, [allEvents, venueId]);

  const selectedVenue = useMemo(() => {
    return venueEvents[0]?.venue || null;
  }, [venueEvents]);

  return (
    <DetailsShell
      isOpen={!!venueId}
      mainScrollRef={mainScrollRef}
      desktopScrollRef={desktopScrollRef}
    >
      <VenueDetailsContent
        venue={selectedVenue}
        venueEvents={venueEvents}
        onClose={onClose}
        openEvent={openEvent}
        fromEventId={fromEventId}
        onBackToEvent={onBackToEvent}
      />
    </DetailsShell>
  );
}

export default VenueDetailsShell;
