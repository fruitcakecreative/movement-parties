import React, { useEffect, useMemo, useState } from "react";
import EventStatusControls from "./events/EventStatusControls";
import { fetchEvents } from "../services/api";
import { formatTime } from "../utils/eventDisplay";
import { eventMatchesTextSearch } from "../utils/eventTextSearch";

function rowTimeLabel(event, timeZone) {
  const raw = event.formatted_start_time || event.start_time;
  if (!raw) return "";
  try {
    const d = new Date(raw);
    if (Number.isNaN(d.getTime())) return "";
    return d.toLocaleString("en-US", {
      month: "short",
      day: "numeric",
      hour: "numeric",
      minute: "2-digit",
      timeZone: timeZone || "America/New_York",
    });
  } catch {
    return formatTime(raw);
  }
}

/**
 * Inline catalog search on profile — same interaction pattern as friend search.
 */
function ProfileEventAddSearch({
  timeZone,
  includePastEvents = false,
  onAfterRsvpChange,
}) {
  const [catalog, setCatalog] = useState([]);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(null);
  const [query, setQuery] = useState("");

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    setLoadError(null);
    fetchEvents(includePastEvents)
      .then((data) => {
        if (cancelled) return;
        setCatalog(Array.isArray(data?.events) ? data.events : []);
      })
      .catch((err) => {
        if (cancelled) return;
        console.error(err);
        setLoadError("Could not load events.");
        setCatalog([]);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [includePastEvents]);

  const filtered = useMemo(() => {
    const q = query.trim();
    if (!q) return [];
    return catalog
      .filter((e) => eventMatchesTextSearch(e, q))
      .slice(0, 24);
  }, [catalog, query]);

  return (
    <div className="profile-page__event-add-search">
      <input
        type="search"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search for events to add"
        autoComplete="off"
        aria-label="Search for events to add to your schedule"
        disabled={loading && catalog.length === 0}
      />
      {loading && catalog.length === 0 && (
        <p className="profile-page__event-add-search-status">Loading event list…</p>
      )}
      {loadError && (
        <p className="profile-page__error" role="alert">
          {loadError}
        </p>
      )}
      {!loading && !loadError && query.trim() && filtered.length === 0 && (
        <p className="profile-page__empty-small">No matches.</p>
      )}
      {!loading && !loadError && query.trim() && filtered.length > 0 && (
        <div className="profile-page__event-add-search-results">
          <ul className="profile-page__event-add-search-list">
            {filtered.map((event) => {
              const when = rowTimeLabel(event, timeZone);
              return (
                <li key={event.id} className="profile-page__event-add-search-row">
                  <div className="profile-page__event-add-search-row-main">
                    <div className="profile-page__event-add-search-row-title">
                      {event.short_title || event.title || "Event"}
                    </div>
                    <div className="profile-page__event-add-search-row-meta">
                      {event.venue?.name ? <span>{event.venue.name}</span> : null}
                      {event.venue?.name && when ? (
                        <span aria-hidden> · </span>
                      ) : null}
                      {when ? <span>{when}</span> : null}
                    </div>
                  </div>
                  <div
                    className="profile-page__event-add-search-row-actions"
                    onClick={(e) => e.stopPropagation()}
                    role="presentation"
                  >
                    <EventStatusControls
                      variant="compact"
                      className="event-status--profile-inline-add"
                      eventId={event.id}
                      showFriendCountHints={false}
                      onAfterRsvpChange={onAfterRsvpChange}
                    />
                  </div>
                </li>
              );
            })}
          </ul>
        </div>
      )}
    </div>
  );
}

export default ProfileEventAddSearch;
