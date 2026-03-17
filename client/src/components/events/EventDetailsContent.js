import React, { useEffect, useRef, useState } from 'react';
import { getEventDisplayData } from '../../utils/eventDisplay';
import { formatDescription } from '../../utils/formatDescription';

function EventDetailsContent({ event, onClose, openVenue, fromVenueId, onBackToVenue }) {
  const contentRef = useRef(null);
  const [showFullDescription, setShowFullDescription] = useState(false);

  const stripHtml = (html = '') => {
    const div = document.createElement('div');
    div.innerHTML = html;
    return div.textContent || div.innerText || '';
  };

  useEffect(() => {
    contentRef.current?.scrollTo(0, 0);
  }, [event?.id]);

  useEffect(() => {
    setShowFullDescription(false);
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
    actionButtons,
    ticketSaleMessage,
  } = getEventDisplayData(event);

  const plainDescription = stripHtml(description || '');
  const previewLength = 145;
  const isLongDescription = plainDescription.length > previewLength;
  const previewDescription = isLongDescription
    ? `${plainDescription.slice(0, previewLength).trim()}...`
    : plainDescription;

  return (
    <div
      ref={contentRef}
      className="event-details-content"
      style={{ minHeight: '100%' }}
    >
      <div className="event-details-header flex mb-sm">
        <div>
        {fromVenueId && onBackToVenue && (
          <button
            type="button"
            className="event-details-back"
            onClick={onBackToVenue}
            aria-label="Back to venue"
          >
            <i className="fa-solid fa-arrow-left" aria-hidden />
            Back to venue
          </button>
        )}
        </div>
        <button className="event-details-close" onClick={onClose} aria-label="Close event details">
          ×
        </button>
      </div>

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
            {venueName &&
              (venueName === "TBA" ? (
                <div className="highlight event-venue mb-xs">
                  Location To Be Announced
                  {location && <span>&nbsp;({location})</span>}
                </div>
              ) : venueName === "TBA - (313) 513 RAVE" ? (
                <div className="highlight event-venue mb-xs">
                  Call Party hotline (313) 513 RAVE for location on the night of the event
                </div>
              ) : venueName === "TBA - Secret Location" ? (
                <div className="highlight event-venue mb-xs">
                  Secret location to be announced
                </div>
              ) : (
                <button
                  type="button"
                  className="event-venue button mb-xs"
                  onClick={() => event?.venue?.id && openVenue?.(event.venue.id, event.id)}
                >
                  <i className="fa-solid fa-map-pin"></i>&nbsp;
                  {venueName}
                  {location && <span>&nbsp;({location})</span>}
                </button>
              ))}
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

        {genres.length > 0 && (
          <div className="event-genres mb-xs">
            <div className="event-details-pills">
              {genres.map((genre) => (
                <span
                  key={genre.id || genre.name}
                  className={`genre-pill ${genre.name}`}
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

        {ticketSaleMessage && (
          <p className="ticket-sale-message mb-xs">
            {ticketSaleMessage}
          </p>
        )}

        {actionButtons.length > 0 && (
          <div className="event-details-actions mb-sm">
            {actionButtons.map((btn, i) => (
              <a
                key={i}
                href={btn.url}
                target="_blank"
                rel="noreferrer"
                className="button mb-xs"
              >
                {btn.label}
              </a>
            ))}
          </div>
        )}
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
