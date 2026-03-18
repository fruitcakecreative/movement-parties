import React, { useEffect, useMemo, useRef, useState } from 'react';
import EventCard from '../EventCard';
import { formatDescription } from '../../utils/formatDescription';

function VenueDetailsContent({ venue, venueEvents = [], onClose, openEvent, fromEventId, onBackToEvent }) {
  const contentRef = useRef(null);
    const [showFullDescription, setShowFullDescription] = useState(false);

  useEffect(() => {
    contentRef.current?.scrollTo(0, 0);
  }, [venue?.id]);

  const groupedEvents = useMemo(() => {
    const sortedEvents = [...venueEvents].sort(
      (a, b) =>
        new Date(a.start_time || a.formatted_start_time) -
        new Date(b.start_time || b.formatted_start_time)
    );

    const childVenues = venue?.child_venues || [];
    const parentId = venue?.id;

    return sortedEvents.reduce((acc, event) => {
      const dayLabel = new Date(
        event.start_time || event.formatted_start_time
      ).toLocaleDateString('en-US', {
        weekday: 'long',
        month: 'short',
        day: 'numeric',
      });

      if (!acc[dayLabel]) acc[dayLabel] = {};

      const venueId = event.venue?.id;
      let subLabel = '_';
      if (childVenues.length) {
        const child = childVenues.find((c) => c.id === venueId);
        if (child) {
          subLabel = child.subheading || child.name;
        } else {
          subLabel = venue?.parent_section_label || venue?.name || 'Events';
        }
      }

      if (!acc[dayLabel][subLabel]) acc[dayLabel][subLabel] = [];
      acc[dayLabel][subLabel].push(event);
      return acc;
    }, {});
  }, [venueEvents, venue?.child_venues, venue?.id, venue?.parent_section_label, venue?.name]);

  if (!venue) {
    return (
      <div ref={contentRef} className="event-details-content">
        <button className="event-details-close" onClick={onClose} aria-label="Close venue details">
          ×
        </button>
        <p>Venue not found.</p>
      </div>
    );
  }

  const {
    name,
    logo_url,
    address,
    location,
    venue_type,
    subheading,
    description,
  } = venue;


  const plainDescription = description
    ? description.replace(/<[^>]+>/g, '').trim()
    : '';

  const isLongDescription = plainDescription.length > 130;
  const previewDescription = isLongDescription
    ? `${plainDescription.slice(0, 130).trim()}...`
    : plainDescription;

  const displayVenueType =
    name === 'Joia Beach' || name === 'National Hotel' || name === 'Tala Beach'
      ? 'Beachclub'
      : venue_type;

  return (
    <div
      ref={contentRef}
      className="event-details-content venue-details-content"
      style={{ minHeight: '100%' }}
    >
      <div className="event-details-header flex mb-sm">
        {fromEventId && onBackToEvent && (
          <button
            type="button"
            className="event-details-back"
            onClick={onBackToEvent}
            aria-label="Back to event"
          >
            <i className="fa-solid fa-arrow-left" aria-hidden />
            Back to event
          </button>
        )}
        <button className="event-details-close" onClick={onClose} aria-label="Close venue details">
          ×
        </button>
      </div>

      {logo_url && venue_type !== 'Pool' && venue_type !== 'Boat' && (
        <img
          src={logo_url}
          alt={name}
          className="event-details-image"
        />
      )}

      {(name === 'Joia Beach' || name === 'National Hotel' || name === 'Tala Beach') && (
        <img
          src={logo_url}
          alt={name}
          className="event-details-image"
        />
      )}

      {!logo_url && (
        <h2>{name}</h2>
      )}

      {subheading && (venue?.child_venues?.length > 0) && (
        <h2 className="event-venue mb-xs highlight">
          {subheading}
        </h2>
      )}

      {(location || address) && (
        <p className="event-venue-address mb-xs">
          <i className="fa-solid fa-map-pin"></i>&nbsp;
          {location}
          {location && address && ' - '}
          {address}
        </p>
      )}

      {displayVenueType && (
        <p className="event-age mb-xs">
          <i className="fa-solid fa-building"></i>&nbsp;
          {displayVenueType}
        </p>
      )}

      {description && (
        <div className="event-description mb-xs">
          {showFullDescription ? (
            <>
              <div dangerouslySetInnerHTML={{ __html: formatDescription(description) }} />
              {isLongDescription && (
                <button
                  type="button"
                  className="description-inline-toggle"
                  onClick={() => setShowFullDescription(false)}
                >
                  Show less
                </button>
              )}
            </>
          ) : (
            <p className="description-preview">
              {previewDescription}
              {isLongDescription && (
                <>
                  {' '}
                  <button
                    type="button"
                    className="description-inline-toggle"
                    onClick={() => setShowFullDescription(true)}
                  >
                    See full description
                  </button>
                </>
              )}
            </p>
          )}
        </div>
      )}
      {venueEvents.length > 0 && (
        <div className="venue-events-list mb-xs">
          {Object.entries(groupedEvents).map(([day, dayGroups]) => {
            const isGroupedBySubVenue = typeof dayGroups === 'object' && !Array.isArray(dayGroups);
            const sections = isGroupedBySubVenue
              ? Object.entries(dayGroups)
              : [['_', dayGroups]];

            return (
              <div key={day} className="venue-event-group mb-sm">
                <h3 className="venue-event-group-title mb-xs">{day}</h3>
                {sections.map(([subLabel, events]) => {
                  const childVenue = venue?.child_venues?.find(
                    (c) => (c.subheading || c.name) === subLabel
                  );
                  const sectionLogo = childVenue?.logo_url;
                  return (
                  <div key={subLabel} className="venue-event-subgroup mb-sm">
                    {subLabel !== '_' && (
                      <div className="venue-event-subgroup-header mb-xs">
                        {sectionLogo && (
                          <img
                            src={sectionLogo}
                            alt={subLabel}
                            className="venue-event-subvenue-logo"
                          />
                        )}
                        <h5 className="venue-event-subvenue-title mb-xs">{subLabel}</h5>
                      </div>
                    )}
                    <div className="venue-event-cards">
                      {events.map((event) => (
                        <EventCard
                          key={event.id}
                          event={event}
                          onClick={() => openEvent?.(event.id, venue?.id)}
                        />
                      ))}
                    </div>
                  </div>
                );
                })}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

export default VenueDetailsContent;
