import React from "react";
import { Link } from "react-router-dom";

function displayAvatarSrc(u) {
  return u?.avatar_url || u?.picture || null;
}

/** Display name only (no email) for event-detail friend lists. */
function displayNameOnly(u) {
  const n = (u?.name || "").trim();
  if (n) return n;
  return (u?.email || "").trim() || "";
}

function displayInitial(u) {
  const base = (u?.name || u?.email || "?").trim() || "?";
  return base.charAt(0).toUpperCase();
}

/**
 * Accepted friends for this event: attending as full profile tiles (match /profile);
 * interested as a simple comma-style list of clickable names.
 */
function EventDetailsFriendSocial({
  friendsAttending = [],
  friendsInterested = [],
  onNavigate,
  /** When set, friend profile links include state so the profile can offer “Back to event”. */
  fromEventId = null,
}) {
  const hasAttending = Array.isArray(friendsAttending) && friendsAttending.length > 0;
  const hasInterested =
    Array.isArray(friendsInterested) && friendsInterested.length > 0;

  if (!hasAttending && !hasInterested) return null;

  const nAttending = friendsAttending.length;
  const nInterested = friendsInterested.length;

  return (
    <div className="event-details-friend-social mb-sm">
      {hasAttending && (
        <div className="event-details-friends-attending event-details-friends-attending--full-blob">
          <h2 className="event-details-section-head">
            <span className="event-details-section-head__row">
              <i className="fa-solid fa-user-group" aria-hidden />
              &nbsp;Friends attending ({nAttending})
            </span>
          </h2>
          <ul className="profile-page__friends-tiles event-details-friends-attending__tiles">
            {friendsAttending.map((friend) => (
              <li key={friend.id} className="profile-page__friend-tile-wrap">
                <Link
                  to={`/users/${friend.id}`}
                  state={fromEventId != null ? { fromEventId } : undefined}
                  className="profile-page__friend-tile"
                  onClick={() => onNavigate?.()}
                >
                  {displayAvatarSrc(friend) ? (
                    <img
                      className="profile-page__friend-tile-img"
                      src={displayAvatarSrc(friend)}
                      alt=""
                    />
                  ) : (
                    <div
                      className="profile-page__friend-tile-avatar profile-page__friend-tile-avatar--placeholder"
                      aria-hidden
                    >
                      {(displayInitial(friend))}
                    </div>
                  )}
                  <span className="profile-page__friend-tile-name">
                    <span className="profile-page__friend-tile-line">
                      {displayNameOnly(friend)}
                    </span>
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}

      {hasInterested && (
        <div className="event-details-friends-interested">
          <h2 className="event-details-section-head">
            <span className="event-details-section-head__row">
              <i className="fa-regular fa-star" aria-hidden />
              &nbsp;Friends interested ({nInterested})
            </span>
          </h2>
          <p className="event-details-friends-interested__line">
            {friendsInterested.map((friend, index) => (
              <span key={friend.id} className="event-details-friends-interested__chunk">
                {index > 0 ? (
                  <span className="event-details-friends-interested__sep" aria-hidden>
                    ,{" "}
                  </span>
                ) : null}
                <Link
                  to={`/users/${friend.id}`}
                  state={fromEventId != null ? { fromEventId } : undefined}
                  className="event-details-friends-interested__link"
                  onClick={() => onNavigate?.()}
                >
                  {displayNameOnly(friend)}
                </Link>
              </span>
            ))}
          </p>
        </div>
      )}
    </div>
  );
}

export default EventDetailsFriendSocial;
