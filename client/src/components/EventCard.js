import React from 'react';
import SheTheyForwardLineupBadge from './SheTheyForwardLineupBadge';
import { getEventDisplayData } from '../utils/eventDisplay';
import { filterArtistsHideHePresenting } from '../utils/pronounDisplay';

function EventCard({
  event,
  onClick,
  timeZone = 'America/New_York',
  sheTheyForwardTimeline = false,
}) {
  const {
    displayTitle,
    timeLabel,
    lateNightActuallyWeekday,
    ticketLabel,
    ticketTier,
    visibleGenres,
    displayArtists,
    cardBg,
    cardFont,
  } = getEventDisplayData(event, { timeZone });

  const artistsOnCard = sheTheyForwardTimeline
    ? filterArtistsHideHePresenting(displayArtists)
    : displayArtists;

  return (
    <button
      type="button"
      className="button event-card full-width padding mb-xs"
      onClick={onClick}
      style={{
        backgroundColor: cardBg,
        color: cardFont,
        borderColor: cardBg,
        '--event-card-font': cardFont,
      }}
    >
      <div className="event-card-inner">
        <SheTheyForwardLineupBadge
          sheTheyForwardTimeline={sheTheyForwardTimeline}
          artists={displayArtists}
          className="event-card-she-they-pct"
        />

        <h5 className="event-card-title">{displayTitle}</h5>

        {timeLabel && (
          <p className="event-card-time">
            <i className="fa-solid fa-clock"></i>&nbsp;
            {timeLabel}
            {lateNightActuallyWeekday && (
              <span className="late-night-inline">
                {' '}
                actually {lateNightActuallyWeekday}
              </span>
            )}
          </p>
        )}

        {artistsOnCard?.length > 0 && (
          <p className="event-card-artists">
            <i className="fa-solid fa-headphones"></i>&nbsp;
            {artistsOnCard.map((artist) => artist.name).join(', ')}
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
