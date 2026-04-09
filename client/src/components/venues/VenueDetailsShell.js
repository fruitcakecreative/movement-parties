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
  timeZone = 'America/New_York',
  sheTheyForwardTimeline = false,
}) {
  const { venueEvents, selectedVenue } = useMemo(() => {
    const events = allEvents || [];
    const initialEvents = events.filter(
      (e) => String(e.venue?.id) === String(venueId)
    );
    const venue = initialEvents[0]?.venue || null;

    // Parent venues: include events from all child venues. Child venues: include events from parent + siblings.
    const venueIds = venue?.venue_ids_for_events;
    const filteredEvents = Array.isArray(venueIds) && venueIds.length > 1
      ? events.filter((e) => venueIds.includes(e.venue?.id))
      : initialEvents;

    // Use display venue (parent) when available - always show parent for child venues
    const displayVenue = venue?.display_venue_for_json;
    const venueToShow = displayVenue
      ? {
          ...venue,
          ...displayVenue,
          logo_url: displayVenue.logo_url || venue.logo_url,
          parent_section_label: displayVenue.parent_section_label ?? venue.parent_section_label,
          child_venues: displayVenue.child_venues ?? venue.child_venues,
        }
      : venue;

    return { venueEvents: filteredEvents, selectedVenue: venueToShow };
  }, [allEvents, venueId]);

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
        timeZone={timeZone}
        sheTheyForwardTimeline={sheTheyForwardTimeline}
      />
    </DetailsShell>
  );
}

export default VenueDetailsShell;
