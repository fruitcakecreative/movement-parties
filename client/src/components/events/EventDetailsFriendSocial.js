import React from "react";
import { Link } from "react-router-dom";

function displayAvatarSrc(u) {
  return u?.avatar_url || u?.picture || null;
}

function displayName(u) {
  return u?.name || u?.username || "";
}

/**
 * Accepted friends for this event: attending as full profile tiles (match /profile);
 * interested as a simple comma-style list of clickable names.
 */
function EventDetailsFriendSocial({
  friendsAttending = [],
  friendsInterested = [],
  onNavigate,
}) {
  const hasAttending = Array.isArray(friendsAttending) && friendsAttending.length > 0;
  const hasInterested =
    Array.isArray(friendsInterested) && friendsInterested.length > 0;

  if (!hasAttending && !hasInterested) return null;

  return (
    <div className="event-details-friend-social mb-sm">
      {hasAttending && (
        <div className="event-details-friends-attending event-details-friends-attending--full-blob">
          <p className="event-details-friends-attending__title">
            <i className="fa-solid fa-user-group" aria-hidden />
            &nbsp;Friends attending:
          </p>
          <ul className="profile-page__friends-tiles event-details-friends-attending__tiles">
            {friendsAttending.map((friend) => (
              <li key={friend.id} className="profile-page__friend-tile-wrap">
                <Link
                  to={`/users/${friend.id}`}
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
                      {(friend.name || friend.username || "?")
                        .charAt(0)
                        .toUpperCase()}
                    </div>
                  )}
                  <span className="profile-page__friend-tile-name">
                    {displayName(friend)}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}

      {hasInterested && (
        <div className="event-details-friends-interested">
          <p className="event-details-friends-interested__title">
            <i className="fa-regular fa-star" aria-hidden />
            &nbsp;Friends interested:
          </p>
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
                  className="event-details-friends-interested__link"
                  onClick={() => onNavigate?.()}
                >
                  {displayName(friend)}
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
