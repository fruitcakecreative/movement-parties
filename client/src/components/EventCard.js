import React from 'react';
import { useFriendCounts } from '../context/FriendCountsContext';
import SheTheyForwardLineupBadge from './SheTheyForwardLineupBadge';
import EventStatusControls from './events/EventStatusControls';
import { getEventDisplayData } from '../utils/eventDisplay';
import { filterArtistsHideHePresenting } from '../utils/pronounDisplay';

function EventCard({
  event,
  onClick,
  timeZone = 'America/New_York',
  sheTheyForwardTimeline = false,
  showVenueName = false,
  showArtists = true,
  /** 'compact' — denser card (e.g. profile “interested” grid). */
  density = 'default',
  /** After RSVP save — e.g. refresh profile day lists. */
  onAfterRsvpChange,
}) {
  const {
    displayTitle,
    venueName,
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

  const { get: friendCountsFor } = useFriendCounts();
  const fc = friendCountsFor(event?.id);

  const stackClass =
    density === 'compact'
      ? 'event-card-stack event-card-stack--compact mb-xs'
      : 'event-card-stack mb-xs';

  return (
    <div
      className={stackClass}
      style={{
        '--event-card-font': cardFont,
        '--event-card-bg': cardBg,
      }}
    >
      <button
        type="button"
        className="button event-card full-width padding"
        onClick={onClick}
        style={{
          backgroundColor: cardBg,
          color: cardFont,
          borderColor: cardBg,
        }}
      >
        <div className="event-card-inner">
          <SheTheyForwardLineupBadge
            sheTheyForwardTimeline={sheTheyForwardTimeline}
            artists={displayArtists}
            className="event-card-she-they-pct"
          />

          <h5 className="event-card-title">{displayTitle}</h5>
          {showVenueName && venueName && (
            <p className="event-card-venue">
              <i className="fa-solid fa-map-pin"></i>&nbsp;
              {venueName}
            </p>
          )}

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

          {showArtists && artistsOnCard?.length > 0 && (
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
      <div
        className="event-card-footer"
        onClick={(e) => e.stopPropagation()}
        role="presentation"
      >
        <EventStatusControls
          variant="card"
          eventId={event?.id}
          friendsInterestedCount={fc.friendsInterested}
          friendsAttendingCount={fc.friendsAttending}
          onAfterRsvpChange={onAfterRsvpChange}
        />
      </div>
    </div>
  );
}

export default EventCard;
