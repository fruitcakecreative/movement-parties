import React, { useEffect, useRef } from 'react';
import { getEventDisplayData } from '../../utils/eventDisplay';

function EventDetailsContent({ event, onClose }) {
  const contentRef = useRef(null);

  useEffect(() => {
    contentRef.current?.scrollTo(0, 0);
  }, [event?.id]);

  if (!event) {
    return (
      <div ref={contentRef} className="event-details-content">
        <button className="event-details-close" onClick={onClose} aria-label="Close event details">
          ×
        </button>
        <p>Event not found.</p>
      </div>
    );
  }

  const {
    displayTitle,
    imageSrc,
    dateLabel,
    timeLabel,
    venueName,
    address,
    displayArtists,
    location,
    genres,
    age,
    ticketLabel,
    ticketTier,
    description,
    ticketUrl,
    eventUrl,
  } = getEventDisplayData(event);

  return (
    <div
      ref={contentRef}
      className="event-details-content"
      style={{ minHeight: '100%' }}
    >
      <button className="event-details-close mb-sm" onClick={onClose} aria-label="Close event details">
        ×
      </button>

      <div className="party-content event-details-card">
        <div className="event-date-time flex mb-xs">
          {dateLabel && (
            <p className="event-date">
              <i className="fa-solid fa-calendar"></i>&nbsp;
              {dateLabel}
            </p>
          )}

          {timeLabel && (
            <p className="event-time">
              <i className="fa-solid fa-clock"></i>&nbsp;
              {timeLabel}
            </p>
          )}
        </div>

        <h1 className="title mb-xs">{displayTitle}</h1>

        <div className="event-venue-location flex">
          {venueName && (
            <p className="event-venue mb-xs">
              <i className="fa-solid fa-map-pin"></i>&nbsp;
              {venueName}
              {location && <span>&nbsp;({location})</span>}
            </p>
          )}
        </div>

        {address && (
          <p className="hide event-address mb-xs">
            <i className="fa-solid fa-location-dot"></i>&nbsp;
            {address}
          </p>
        )}

        {age && (
          <p className="event-age mb-xs">
            <i className="fa-solid fa-id-card"></i>&nbsp;
            {age}
          </p>
        )}

        {(ticketLabel || ticketTier) && (
          <p className="event-ticket mb-xs">
            <i className="fa-solid fa-ticket"></i>&nbsp;
            {ticketLabel} {ticketTier}
          </p>
        )}

        {description && (
          <div
            className="event-description mb-xs"
            dangerouslySetInnerHTML={{ __html: description }}
          />
        )}

        {genres.length > 0 && (
          <div className="event-genres mb-xs">
            <div className="event-details-pills">
              {genres.map((genre) => (
                <span
                  key={genre.id || genre.name}
                  className="genre-pill"
                  style={{
                    backgroundColor: genre.hex_color || '#ccc',
                    color: genre.font_color || '#000',
                  }}
                >
                  {genre.short_name || genre.name}
                </span>
              ))}
            </div>
          </div>
        )}

        {displayArtists.length > 0 && (
          <div className="event-artists mb-xs">
            <p>
              <i className="fa-solid fa-headphones"></i>&nbsp;
              Artists:
            </p>
            <ul>
              {displayArtists.map((artist, i) => (
                <li key={artist.id || `${artist.name}-${i}`}>{artist.name}</li>
              ))}
            </ul>
          </div>
        )}

        <div className="event-details-actions mb-sm">
          {ticketUrl && (
            <a href={ticketUrl} target="_blank" rel="noreferrer" className="button mb-sm">
              Buy Tickets
            </a>
          )}

          {eventUrl && (
            <a href={eventUrl} target="_blank" rel="noreferrer" className="button">
              View on RA
            </a>
          )}
        </div>
      </div>

      {imageSrc && (
        <img
          src={imageSrc}
          alt={displayTitle}
          className="event-details-image"
        />
      )}
    </div>
  );
}

export default EventDetailsContent;
