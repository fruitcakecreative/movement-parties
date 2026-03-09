import React from 'react';
import { getEventDisplayData } from '../utils/eventDisplay';

function EventCard({ event, onClick }) {
  const {
    displayTitle,
    timeLabel,
    ticketLabel,
    ticketTier,
    visibleGenres,
    displayArtists,
    cardBg,
    cardFont,
  } = getEventDisplayData(event);

  return (
    <button
      type="button"
      className="button event-card full-width padding mb-xs"
      onClick={onClick}
      style={{
        backgroundColor: cardBg,
        color: cardFont,
        borderColor: cardBg,
      }}
    >
      <div className="event-card-inner">
        <h5 className="event-card-title">{displayTitle}</h5>

        {timeLabel && (
          <p className="event-card-time">
            <i className="fa-solid fa-clock"></i>&nbsp;
            {timeLabel}
          </p>
        )}

        {displayArtists?.length > 0 && (
          <p className="event-card-artists">
            <i className="fa-solid fa-headphones"></i>&nbsp;
            {displayArtists.map((artist) => artist.name).join(', ')}
          </p>
        )}

        {visibleGenres?.length > 0 && (
          <div className="event-details-pills">
            {visibleGenres.map((genre) => (
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
        )}
        {(ticketLabel || ticketTier) && (
          <p className="event-card-ticket">
            <i className="fa-solid fa-ticket"></i>&nbsp;
            {ticketLabel} {ticketTier}
          </p>
        )}
      </div>
    </button>
  );
}

export default EventCard;
