import { useEffect, useMemo, useRef, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import EventDetailsShell from "../components/events/EventDetailsShell";
import VenueDetailsShell from "../components/venues/VenueDetailsShell";
import MiniProgramBox from "../timeline/components/MiniProgramBox";
import {
  fetchUserPublicProfile,
  fetchUserEventsForUser,
  cancelFriendRequest,
  isUnauthorized,
} from "../services/api";
import { FriendCountsProvider } from "../context/FriendCountsContext";
import { loadCityConfig } from "../services/cityConfig";
import { getSortedEventDayEntries } from "../utils/profileEventsByDay";

const cfg = await loadCityConfig();
const timelineTimeZone =
  cfg.timezone ||
  (process.env.REACT_APP_CITY_KEY === "movement"
    ? "America/Detroit"
    : "America/New_York");

function displayAvatarSrc(u) {
  return u?.avatar_url || u?.picture || null;
}

export default function UserProfile() {
  const { userId } = useParams();
  const navigate = useNavigate();
  const mainScrollRef = useRef(null);
  const desktopScrollRef = useRef(0);
  const [selectedEventId, setSelectedEventId] = useState(null);
  const [selectedVenueId, setSelectedVenueId] = useState(null);
  const [fromVenueId, setFromVenueId] = useState(null);
  const [fromEventId, setFromEventId] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [actionError, setActionError] = useState("");
  const [friendUserEvents, setFriendUserEvents] = useState({
    attending: [],
    interested: [],
  });
  const [eventsLoading, setEventsLoading] = useState(false);
  const [eventsError, setEventsError] = useState("");

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    setError("");
    setActionError("");
    fetchUserPublicProfile(userId)
      .then((data) => {
        if (!cancelled) setProfile(data);
      })
      .catch((err) => {
        if (cancelled) return;
        if (isUnauthorized(err)) setError("signin");
        else setError("notfound");
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [userId]);

  useEffect(() => {
    if (!profile?.id) return;
    if (!profile.is_friend && !profile.is_self) return;

    let cancelled = false;
    setEventsLoading(true);
    setEventsError("");
    fetchUserEventsForUser(profile.id)
      .then((data) => {
        if (cancelled) return;
        setFriendUserEvents({
          attending: data?.attending || [],
          interested: data?.interested || [],
        });
      })
      .catch((err) => {
        if (cancelled) return;
        console.error("Failed to load friend events", err);
        setEventsError("Could not load their events.");
      })
      .finally(() => {
        if (!cancelled) setEventsLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [profile]);

  const eventsByDay = useMemo(
    () => getSortedEventDayEntries(friendUserEvents),
    [friendUserEvents]
  );
  const hasEventsByDay = eventsByDay.length > 0;

  const allFriendEvents = useMemo(() => {
    const attending = friendUserEvents.attending || [];
    const interested = friendUserEvents.interested || [];
    const byId = new Map();
    for (const e of [...attending, ...interested]) {
      if (e?.id != null) byId.set(String(e.id), e);
    }
    return [...byId.values()];
  }, [friendUserEvents]);

  const friendCountEventIds = useMemo(
    () => allFriendEvents.map((e) => e.id).filter((id) => id != null),
    [allFriendEvents]
  );

  const sheTheyForwardTimeline = false;

  const openEvent = (eventId, fromVenue) => {
    const isMobile = window.innerWidth < 768;
    if (!isMobile) {
      if ((selectedEventId || selectedVenueId) && mainScrollRef.current) {
        desktopScrollRef.current = mainScrollRef.current.scrollTop;
      } else {
        desktopScrollRef.current = window.scrollY;
      }
    }
    setSelectedVenueId(null);
    setFromEventId(null);
    setSelectedEventId(String(eventId));
    setFromVenueId(fromVenue ? String(fromVenue) : null);
  };

  const closeEvent = () => {
    const isMobile = window.innerWidth < 768;
    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }
    setSelectedEventId(null);
    setFromVenueId(null);
  };

  const goBackToVenue = () => {
    if (!fromVenueId) return;
    setSelectedEventId(null);
    setSelectedVenueId(String(fromVenueId));
    setFromVenueId(null);
  };

  const openVenue = (venueId, fromEvent) => {
    const isMobile = window.innerWidth < 768;
    if (!isMobile) {
      if ((selectedEventId || selectedVenueId) && mainScrollRef.current) {
        desktopScrollRef.current = mainScrollRef.current.scrollTop;
      } else {
        desktopScrollRef.current = window.scrollY;
      }
    }
    setSelectedEventId(null);
    setFromVenueId(null);
    setSelectedVenueId(String(venueId));
    setFromEventId(fromEvent ? String(fromEvent) : null);
  };

  const closeVenue = () => {
    const isMobile = window.innerWidth < 768;
    if (!isMobile && mainScrollRef.current) {
      desktopScrollRef.current = mainScrollRef.current.scrollTop;
    }
    setSelectedVenueId(null);
    setFromEventId(null);
  };

  const goBackToEvent = () => {
    if (!fromEventId) return;
    setSelectedVenueId(null);
    setSelectedEventId(fromEventId);
    setFromEventId(null);
  };

  const handleUnfriend = async () => {
    if (!profile) return;
    setBusy(true);
    setActionError("");
    try {
      await cancelFriendRequest({
        user_id: profile.id,
        username: profile.username,
      });
      navigate("/profile");
    } catch (e) {
      const msg =
        e?.response?.data?.error || e?.response?.data?.message || "Could not unfriend.";
      setActionError(typeof msg === "string" ? msg : "Could not unfriend.");
    } finally {
      setBusy(false);
    }
  };

  if (loading) {
    return (
      <div className="profile-page user-profile-page">
        <p className="profile-page__empty">Loading…</p>
      </div>
    );
  }

  if (error === "signin") {
    return (
      <div className="profile-page user-profile-page">
        <p className="profile-page__empty">
          <a href="/login">Sign in</a> to view this profile.
        </p>
      </div>
    );
  }

  if (error || !profile) {
    return (
      <div className="profile-page user-profile-page">
        <p className="profile-page__empty">
          Profile unavailable or you are not friends with this user.
        </p>
        <p className="profile-page__empty-small">
          <Link to="/profile">Back to your profile</Link>
        </p>
      </div>
    );
  }

  const src = displayAvatarSrc(profile);
  const showEventSection = profile.is_friend || profile.is_self;
  const detailsOpen = !!(selectedEventId || selectedVenueId);

  return (
    <FriendCountsProvider eventIds={friendCountEventIds}>
    <div
      className={`profile-page user-profile-page${detailsOpen ? " has-selected-event" : ""}`}
    >
      <div ref={mainScrollRef} className="user-profile-page__main">
      <nav className="user-profile-page__nav" aria-label="Profile">
        <Link to="/profile" className="user-profile-page__back">
          ← Back to profile
        </Link>
      </nav>

      <div className="profile-page__hero">
        <div className="profile-page__avatar-wrap user-profile-page__avatar-wrap">
          {src ? (
            <img className="profile-page__avatar" src={src} alt="" />
          ) : (
            <div
              className="profile-page__avatar profile-page__avatar--placeholder"
              aria-hidden
            >
              {(profile.name || profile.username || "?").charAt(0).toUpperCase()}
            </div>
          )}
        </div>
        <h1 className="profile-page__title">{profile.name || profile.username}</h1>
        <p className="user-profile-page__username">@{profile.username}</p>
      </div>

      {profile.is_self ? (
        <div className="user-profile-page__actions">
          <Link to="/profile" className="profile-page__btn profile-page__btn--primary">
            Edit my profile
          </Link>
        </div>
      ) : profile.is_friend ? (
        <div className="user-profile-page__actions">
          {actionError && (
            <p className="profile-page__error" role="alert">
              {actionError}
            </p>
          )}
          <button
            type="button"
            className="profile-page__btn profile-page__btn--ghost"
            disabled={busy}
            onClick={handleUnfriend}
          >
            Unfriend
          </button>
        </div>
      ) : null}

      {showEventSection && (
        <section
          className="profile-page__section user-profile-page__events"
          aria-label="Interested and attending"
        >
          {eventsLoading && (
            <p className="profile-page__empty-small">Loading events…</p>
          )}
          {eventsError && (
            <p className="profile-page__error" role="alert">
              {eventsError}
            </p>
          )}
          {!eventsLoading &&
            !eventsError &&
            hasEventsByDay &&
            eventsByDay.map(([dayKey, dayData]) => (
              <section key={dayKey} className="profile-page__group-day">
                <h2 className="profile-page__section-title">{dayData.label}</h2>

                {dayData.attending.length > 0 && (
                  <div className="profile-page__status-group profile-page__status-group--attending">
                    <h3 className="profile-page__subsection-title">Attending</h3>
                    {dayData.attending.map((event, i) => (
                      <MiniProgramBox
                        key={`att-${event.id || i}`}
                        event={event}
                        onClick={() => openEvent(event.id)}
                      />
                    ))}
                  </div>
                )}

                {dayData.interested.length > 0 && (
                  <div className="profile-page__status-group profile-page__status-group--interested">
                    <h3 className="profile-page__subsection-title">Interested</h3>
                    {dayData.interested.map((event, i) => (
                      <MiniProgramBox
                        key={`int-${event.id || i}`}
                        event={event}
                        onClick={() => openEvent(event.id)}
                      />
                    ))}
                  </div>
                )}
              </section>
            ))}
          {!eventsLoading && !eventsError && !hasEventsByDay && (
            <p className="profile-page__empty-small">
              No upcoming interested or attending events to show.
            </p>
          )}
        </section>
      )}
      </div>
      <EventDetailsShell
        eventId={selectedEventId}
        allEvents={allFriendEvents}
        onClose={closeEvent}
        mainScrollRef={mainScrollRef}
        desktopScrollRef={desktopScrollRef}
        openVenue={openVenue}
        fromVenueId={fromVenueId}
        onBackToVenue={goBackToVenue}
        timeZone={timelineTimeZone}
        sheTheyForwardTimeline={sheTheyForwardTimeline}
      />
      <VenueDetailsShell
        venueId={selectedVenueId}
        allEvents={allFriendEvents}
        onClose={closeVenue}
        mainScrollRef={mainScrollRef}
        desktopScrollRef={desktopScrollRef}
        openEvent={openEvent}
        fromEventId={fromEventId}
        onBackToEvent={goBackToEvent}
        timeZone={timelineTimeZone}
        sheTheyForwardTimeline={sheTheyForwardTimeline}
      />
    </div>
    </FriendCountsProvider>
  );
}
