import React, { useEffect, useRef, useState } from 'react';
import ArtistNameLine from '../ArtistNameLine';
import { getEventDisplayData } from '../../utils/eventDisplay';
import SheTheyForwardLineupBadge from '../SheTheyForwardLineupBadge';
import {
  artistDetailRowClass,
  artistIsHePresenting,
  artistSheTheyListSortRank,
  artistsSheTheyLineupSubtitle,
} from '../../utils/pronounDisplay';
import { formatDescription } from '../../utils/formatDescription';
import EventStatusControls from './EventStatusControls';
import EventDetailsFriendSocial from './EventDetailsFriendSocial';
import { fetchFriendEventRsvps, fetchEventRsvpTotals } from '../../services/api';
import { useUserEvents } from '../../context/UserEventsContext';

function EventDetailsContent({
  event,
  onClose,
  openVenue,
  fromVenueId,
  onBackToVenue,
  timeZone = 'America/New_York',
  sheTheyForwardTimeline = false,
}) {
  const contentRef = useRef(null);
  const [showFullDescription, setShowFullDescription] = useState(false);
  const [friendRsvps, setFriendRsvps] = useState({ attending: [], interested: [] });
  const [siteRsvpTotals, setSiteRsvpTotals] = useState({ interested: 0, attending: 0 });

  const { getStatus } = useUserEvents();
  const myPlanStatus = event?.id != null ? getStatus(Number(event.id)) : null;

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

  useEffect(() => {
    let cancelled = false;
    const id = event?.id;
    if (!id) {
      setFriendRsvps({ attending: [], interested: [] });
      return;
    }
    fetchFriendEventRsvps(id)
      .then((payload) => {
        if (!cancelled) {
          setFriendRsvps({
            attending: payload?.attending ?? [],
            interested: payload?.interested ?? [],
          });
        }
      })
      .catch(() => {
        if (!cancelled) setFriendRsvps({ attending: [], interested: [] });
      });
    return () => {
      cancelled = true;
    };
  }, [event?.id]);

  useEffect(() => {
    let cancelled = false;
    const id = event?.id;
    if (!id) {
      setSiteRsvpTotals({ interested: 0, attending: 0 });
      return;
    }
    fetchEventRsvpTotals(id).then((totals) => {
      if (!cancelled) {
        setSiteRsvpTotals({
          interested: totals?.interested ?? 0,
          attending: totals?.attending ?? 0,
        });
      }
    });
    return () => {
      cancelled = true;
    };
  }, [event?.id, myPlanStatus]);


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
    lateNightActuallyWeekday,
  } = getEventDisplayData(event, { timeZone });


  const plainDescription = stripHtml(description || '');
  const previewLength = 145;
  const isLongDescription = plainDescription.length > previewLength;
  const previewDescription = isLongDescription
    ? `${plainDescription.slice(0, previewLength).trim()}...`
    : plainDescription;

  const sortedDisplayArtists = [...displayArtists].sort((a, b) => {
    if (sheTheyForwardTimeline) {
      const ra = artistSheTheyListSortRank(a.pronouns);
      const rb = artistSheTheyListSortRank(b.pronouns);
      if (ra !== rb) return ra - rb;
    } else {
      const aHe = artistIsHePresenting(a.pronouns);
      const bHe = artistIsHePresenting(b.pronouns);
      if (aHe !== bHe) return aHe ? 1 : -1;
    }
    return (a.name || '').localeCompare(b.name || '', undefined, { sensitivity: 'base' });
  });

  const artistsSheTheySub =
    sortedDisplayArtists.length > 0
      ? artistsSheTheyLineupSubtitle(sortedDisplayArtists)
      : null;

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
              {lateNightActuallyWeekday && (
                <span className="italic late-night-inline">
                  {' '}
                  (actually {lateNightActuallyWeekday})
                </span>
              )}
            </p>
          )}
        </div>

      
        <SheTheyForwardLineupBadge
          sheTheyForwardTimeline={sheTheyForwardTimeline}
          artists={sortedDisplayArtists}
          className="mb-xs"
        />

        <h1 className="title mb-xs">{displayTitle}</h1>

        {actionButtons.length > 0 && (
          <div className="event-details-actions event-details-actions--below-title mb-sm">
            {actionButtons.map((btn, i) => (
              <div key={i} className="event-details-actions__item">
                <a
                  href={btn.url}
                  target="_blank"
                  rel="noreferrer"
                  className="button mb-xs"
                >
                  {btn.label}
                </a>
                {btn.crowdNote ? (
                  <span className="event-details-actions__crowd-note">{btn.crowdNote}</span>
                ) : null}
              </div>
            ))}
          </div>
        )}

        <div className="event-details-block event-details-block--status mb-sm">
          <p className="event-details-kicker">Your plan</p>
          <EventStatusControls
            variant="pills"
            className="event-status--pills-inline"
            eventId={event?.id}
            showFriendCountHints={false}
            siteInterestedTotal={siteRsvpTotals.interested}
            siteAttendingTotal={siteRsvpTotals.attending}
          />
        </div>

        <div className="event-details-block event-details-block--where mb-sm">
          <p className="event-details-kicker event-details-kicker--where">Venue & info</p>
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
                <>
                <button
                  type="button"
                  className="event-venue button mb-xs"
                  onClick={() => event?.venue?.id && openVenue?.(event.venue.id, event.id)}
                >
                  <p>
                    <i className="fa-solid fa-map-pin"></i>&nbsp;
                    {venueName}
                  </p>
                </button>
              </>
              ))}
          </div>

          <div>
            {location && (
              <p>
                <i className="fa-regular fa-map" aria-hidden /> {location}
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

        </div>

        <EventDetailsFriendSocial
          friendsAttending={friendRsvps.attending}
          friendsInterested={friendRsvps.interested}
          onNavigate={onClose}
          fromEventId={event?.id}
        />

        {(description || genres.length > 0) && (
          <div className="event-description mb-sm">
            <h2 className="event-details-section-head">
              <span className="event-details-section-head__row">
                <i className="fa-solid fa-align-left" aria-hidden />
                &nbsp;Description
              </span>
            </h2>
            {genres.length > 0 && (
              <div className="event-description__genres event-genres mb-sm">
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
            {description &&
              (showFullDescription ? (
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
              ))}
          </div>
        )}

        {sortedDisplayArtists.length > 0 && (
          <div
            className={`event-artists mb-xs${sheTheyForwardTimeline ? ' event-artists--she-they' : ''}`}
          >
            <h2 className="event-details-section-head event-details-section-head--artists">
              <span className="event-details-section-head__row event-details-section-head__row--artists">
                <span className="event-details-section-head__title">
                  <i className="fa-solid fa-headphones" aria-hidden />
                  &nbsp;Artists
                </span>
                {artistsSheTheySub ? (
                  <span className="event-details-section-head__inline-note">{artistsSheTheySub}</span>
                ) : null}
              </span>
            </h2>
            <ul>
              {sortedDisplayArtists.map((artist, i) => (
                <li
                  key={artist.id || `${artist.name}-${i}`}
                  className={artistDetailRowClass(artist.pronouns, sheTheyForwardTimeline)}
                >
                  <ArtistNameLine artist={artist} />
                </li>
              ))}
            </ul>
          </div>
        )}


        {ticketSaleMessage && (
          <p className="ticket-sale-message mb-xs">
            {ticketSaleMessage}
          </p>
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
