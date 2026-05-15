import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Link } from "react-router-dom";
import ModalLayout from "../timeline/components/modals/ModalLayout";
import EventCard from "../components/EventCard";
import ProfileEventAddSearch from "../components/ProfileEventAddSearch";
import ProfileScheduleShareButton from "../components/ProfileScheduleShareButton";
import ProfileSubsectionLabel from "../components/profile/ProfileSubsectionLabel";
import ProfileExtraInfoBanner from "../components/profile/ProfileExtraInfoBanner";
import ProfileExtraInfoDisplay from "../components/profile/ProfileExtraInfoDisplay";
import ProfileExtraInfoFields from "../components/profile/ProfileExtraInfoFields";
import ProfileExtraInfoModal from "../components/profile/ProfileExtraInfoModal";
import {
  emptyProfileExtra,
  hasAnyProfileExtra,
  isProfileExtraBannerDismissed,
  normalizeProfileExtra,
} from "../utils/profileExtraInfo";
import EventDetailsShell from "../components/events/EventDetailsShell";
import VenueDetailsShell from "../components/venues/VenueDetailsShell";

import {
  userLogout,
  fetchUserInfo,
  fetchUserEvents,
  uploadUserAvatar,
  fetchFriendshipList,
  fetchPendingFriendRequests,
  searchUsers,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  isUnauthorized,
  updateCurrentUser,
} from "../services/api";
import { FriendCountsProvider } from "../context/FriendCountsContext";
import { useUserEvents } from "../context/UserEventsContext";
import { getSortedEventDayEntries } from "../utils/profileEventsByDay";
import { loadCityConfig } from "../services/cityConfig";

const cfg = await loadCityConfig();
const timelineTimeZone =
  cfg.timezone ||
  (process.env.REACT_APP_CITY_KEY === "movement"
    ? "America/Detroit"
    : "America/New_York");
const profileEventsIncludePast = !!cfg.showAllTimelineDays;

function Profile() {
  const { refresh: refreshUserEventContext } = useUserEvents();
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [userEvents, setUserEvents] = useState({});
  const [isOpen, setIsOpen] = useState(false);
  const [extraInfoOpen, setExtraInfoOpen] = useState(false);
  const [extraSaveBusy, setExtraSaveBusy] = useState(false);
  const [extraSaveError, setExtraSaveError] = useState(null);
  const [sessionChecked, setSessionChecked] = useState(false);
  const [sessionError, setSessionError] = useState(false);

  const [avatarFile, setAvatarFile] = useState(null);
  const [localPreview, setLocalPreview] = useState(null);
  const [uploadBusy, setUploadBusy] = useState(false);
  const [uploadError, setUploadError] = useState(null);
  const [friendSearch, setFriendSearch] = useState("");
  const [friendSearchResults, setFriendSearchResults] = useState([]);
  const [friends, setFriends] = useState([]);
  const [incomingRequests, setIncomingRequests] = useState([]);
  const [friendBusy, setFriendBusy] = useState(false);
  const [friendError, setFriendError] = useState("");

  const [selectedEventId, setSelectedEventId] = useState(null);
  const [selectedVenueId, setSelectedVenueId] = useState(null);
  const [fromVenueId, setFromVenueId] = useState(null);
  const [fromEventId, setFromEventId] = useState(null);
  const mainScrollRef = useRef(null);
  const desktopScrollRef = useRef(0);

  const [editName, setEditName] = useState("");
  const [editEmail, setEditEmail] = useState("");
  const [editExtra, setEditExtra] = useState(emptyProfileExtra);
  const [accountBusy, setAccountBusy] = useState(false);
  const [accountError, setAccountError] = useState(null);
  const [extraBannerHidden, setExtraBannerHidden] = useState(false);

  const fileInputRef = useRef(null);

  const syncUserSchedule = useCallback(() => {
    refreshUserEventContext();
    fetchUserEvents()
      .then((data) => setUserEvents(data))
      .catch(() => {});
  }, [refreshUserEventContext]);

  const openModal = () => {
    document.body.style.overflow = "hidden";
    setUploadError(null);
    setIsOpen(true);
  };

  const openExtraInfoModal = () => {
    document.body.style.overflow = "hidden";
    setExtraSaveError(null);
    setExtraInfoOpen(true);
  };

  const closeExtraInfoModal = () => {
    document.body.style.overflow = "";
    setExtraInfoOpen(false);
    setExtraSaveError(null);
  };

  const closeModal = () => {
    document.body.style.overflow = "";
    setIsOpen(false);
    if (localPreview) {
      URL.revokeObjectURL(localPreview);
      setLocalPreview(null);
    }
    setAvatarFile(null);
    setUploadError(null);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  useEffect(() => {
    fetchUserInfo()
      .then((data) => {
        setUser(data);
        setProfile(data);
      })
      .catch((err) => {
        if (isUnauthorized(err)) setSessionError(true);
        else console.error(err);
      })
      .finally(() => setSessionChecked(true));
  }, []);

  useEffect(() => {
    if (!user) return;

    fetchUserEvents()
      .then((data) => setUserEvents(data))
      .catch((err) => console.error("Failed to fetch user events", err));

    Promise.all([fetchFriendshipList(), fetchPendingFriendRequests()])
      .then(([friendsData, pendingData]) => {
        setFriends(Array.isArray(friendsData) ? friendsData : []);
        setIncomingRequests(Array.isArray(pendingData) ? pendingData : []);
      })
      .catch((err) => console.error("Failed to fetch friendships", err));
  }, [user]);

  useEffect(() => {
    const query = friendSearch.trim();
    if (!query) {
      setFriendSearchResults([]);
      return;
    }

    const id = window.setTimeout(() => {
      searchUsers(query)
        .then((data) => setFriendSearchResults(Array.isArray(data) ? data : []))
        .catch((err) => {
          console.error("Friend search failed", err);
          setFriendSearchResults([]);
        });
    }, 250);

    return () => window.clearTimeout(id);
  }, [friendSearch]);

  useEffect(
    () => () => {
      if (localPreview) URL.revokeObjectURL(localPreview);
    },
    [localPreview]
  );

  useEffect(() => {
    if (!isOpen || !user) return;
    setEditName(user.name || "");
    setEditEmail(user.email || "");
    setEditExtra(normalizeProfileExtra(user.profile_extra));
    setAccountError(null);
  }, [isOpen, user?.id]);

  const displayAvatarSrc = (u) =>
    u?.avatar_url || u?.picture || null;

  const onAvatarFileChange = (e) => {
    const file = e.target.files?.[0];
    if (localPreview) {
      URL.revokeObjectURL(localPreview);
      setLocalPreview(null);
    }
    if (!file) {
      setAvatarFile(null);
      return;
    }
    if (!file.type.startsWith("image/")) {
      setUploadError("Please choose an image (JPEG, PNG, or WebP).");
      setAvatarFile(null);
      return;
    }
    if (file.size > 8 * 1024 * 1024) {
      setUploadError("Image must be 8MB or smaller.");
      setAvatarFile(null);
      return;
    }
    setUploadError(null);
    setAvatarFile(file);
    setLocalPreview(URL.createObjectURL(file));
  };

  const handleUploadAvatar = async () => {
    if (!avatarFile) return;
    setUploadBusy(true);
    setUploadError(null);
    const previewToRevoke = localPreview;
    try {
      await uploadUserAvatar(avatarFile);
      const data = await fetchUserInfo();
      setUser(data);
      setProfile(data);
      if (previewToRevoke) URL.revokeObjectURL(previewToRevoke);
      setLocalPreview(null);
      setAvatarFile(null);
      if (fileInputRef.current) fileInputRef.current.value = "";
      document.body.style.overflow = "";
      setIsOpen(false);
    } catch (err) {
      const d = err?.response?.data;
      const msg = d?.error || d?.message || err?.message;
      setUploadError(
        typeof msg === "string" ? msg : "Could not upload photo. Try again."
      );
    } finally {
      setUploadBusy(false);
    }
  };

  const eventsByDay = useMemo(
    () => getSortedEventDayEntries(userEvents),
    [userEvents]
  );

  const hasEventsByDay = eventsByDay.length > 0;

  const profileEventIdsForCounts = useMemo(() => {
    const attending = userEvents.attending || [];
    const interested = userEvents.interested || [];
    const byId = new Map();
    for (const e of [...attending, ...interested]) {
      if (e?.id != null) byId.set(String(e.id), e.id);
    }
    return [...byId.values()];
  }, [userEvents]);

  const allProfileEvents = useMemo(() => {
    const attending = userEvents.attending || [];
    const interested = userEvents.interested || [];
    const byId = new Map();
    for (const e of [...attending, ...interested]) {
      if (e?.id != null) byId.set(String(e.id), e);
    }
    return [...byId.values()];
  }, [userEvents]);

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

  const persistUserToStorage = (data) => {
    try {
      const raw = localStorage.getItem("user");
      if (!raw) return;
      const u = JSON.parse(raw);
      if (data.name != null) u.name = data.name;
      if (data.email != null) u.email = data.email;
      if (data.profile_extra != null) u.profile_extra = data.profile_extra;
      if (data.authentication_token) u.authentication_token = data.authentication_token;
      if (data.authentication_token) u.token = data.authentication_token;
      localStorage.setItem("user", JSON.stringify(u));
    } catch (_) {
      /* ignore */
    }
  };

  const handleSaveProfileExtra = async (extra) => {
    const data = await updateCurrentUser({ profile_extra: extra });
    setUser(data);
    setProfile(data);
    return data;
  };

  const handleSaveExtraInfoModal = async (extra) => {
    setExtraSaveBusy(true);
    setExtraSaveError(null);
    try {
      await handleSaveProfileExtra(extra);
      closeExtraInfoModal();
    } catch (err) {
      const errs = err?.response?.data?.errors;
      const msg =
        Array.isArray(errs) && errs.length
          ? errs.join(" ")
          : err?.response?.data?.error || err?.message || "Could not save.";
      setExtraSaveError(typeof msg === "string" ? msg : "Could not save.");
    } finally {
      setExtraSaveBusy(false);
    }
  };

  const showExtraInfoBanner =
    !extraBannerHidden &&
    !isProfileExtraBannerDismissed() &&
    !hasAnyProfileExtra(user?.profile_extra);

  const handleSaveAccount = async () => {
    setAccountBusy(true);
    setAccountError(null);
    try {
      const data = await updateCurrentUser({
        name: editName,
        email: editEmail,
        profile_extra: editExtra,
      });
      setUser(data);
      setProfile(data);
      persistUserToStorage(data);
      closeModal();
    } catch (err) {
      const errs = err?.response?.data?.errors;
      const msg =
        Array.isArray(errs) && errs.length
          ? errs.join(" ")
          : err?.response?.data?.error || err?.message || "Could not save.";
      setAccountError(typeof msg === "string" ? msg : "Could not save.");
    } finally {
      setAccountBusy(false);
    }
  };

  const refreshFriendsData = async () => {
    const [friendsData, pendingData] = await Promise.all([
      fetchFriendshipList(),
      fetchPendingFriendRequests(),
    ]);
    setFriends(Array.isArray(friendsData) ? friendsData : []);
    setIncomingRequests(Array.isArray(pendingData) ? pendingData : []);
  };

  const handleSendFriendRequest = async (candidate) => {
    setFriendError("");
    setFriendBusy(true);
    try {
      await sendFriendRequest({ user_id: candidate.id });
      setFriendSearchResults((results) =>
        results.map((u) =>
          u.id === candidate.id ? { ...u, friendship_status: "outgoing_pending" } : u
        )
      );
    } catch (err) {
      const msg = err?.response?.data?.error || err?.response?.data?.message || "Could not send request.";
      setFriendError(msg);
    } finally {
      setFriendBusy(false);
    }
  };

  const renderFriendSearchAction = (candidate) => {
    const status = candidate.friendship_status || "none";
    if (status === "friend") {
      return (
        <span className="profile-page__friend-action-label" aria-live="polite">
          Friends
        </span>
      );
    }
    if (status === "outgoing_pending") {
      return (
        <span className="profile-page__friend-action-label" aria-live="polite">
          Pending
        </span>
      );
    }
    if (status === "incoming_pending") {
      return (
        <span className="profile-page__friend-action-label" aria-live="polite">
          In requests
        </span>
      );
    }
    return (
      <button
        type="button"
        disabled={friendBusy}
        onClick={() => handleSendFriendRequest(candidate)}
      >
        Add
      </button>
    );
  };

  const handleAcceptRequest = async (requester) => {
    setFriendError("");
    setFriendBusy(true);
    try {
      await acceptFriendRequest(requester.id);
      await refreshFriendsData();
    } catch (err) {
      const msg = err?.response?.data?.error || "Could not accept request.";
      setFriendError(msg);
    } finally {
      setFriendBusy(false);
    }
  };

  const handleRejectRequest = async (requester) => {
    setFriendError("");
    setFriendBusy(true);
    try {
      await rejectFriendRequest(requester.id);
      await refreshFriendsData();
    } catch (err) {
      const msg = err?.response?.data?.error || "Could not reject request.";
      setFriendError(msg);
    } finally {
      setFriendBusy(false);
    }
  };

  if (!sessionChecked) {
    return (
      <div className="profile-page">
        <p className="profile-page__empty">Loading your profile…</p>
      </div>
    );
  }

  if (sessionError) {
    return (
      <div className="profile-page">
        <div
          className="profile-page__guest-gate"
          role="region"
          aria-labelledby="profile-guest-heading"
        >
          <h1 id="profile-guest-heading" className="profile-page__guest-title">
            Your profile
          </h1>
          <p className="profile-page__guest-lede">
            Log in or create an account to save events, connect with friends, and manage your
            festival plans.
          </p>
          <div className="profile-page__guest-actions">
            <Link to="/login" className="profile-page__btn profile-page__btn--primary">
              Log in
            </Link>
            <Link to="/signup" className="profile-page__btn profile-page__btn--ghost">
              Create an account
            </Link>
          </div>
        </div>
      </div>
    );
  }

  if (!user || !profile) return null;

  const heroSrc = displayAvatarSrc(user);
  const modalPreview = localPreview || heroSrc;
  const detailsOpen = !!(selectedEventId || selectedVenueId);

  return (
    <>
      <FriendCountsProvider eventIds={profileEventIdsForCounts}>
      <div
        className={`profile-page${detailsOpen ? " user-profile-page has-selected-event" : ""}`}
      >
        <div
          ref={mainScrollRef}
          className={detailsOpen ? "user-profile-page__main" : undefined}
        >
        <div className="profile-page__hero">
          <div className="profile-page__avatar-wrap">
            {heroSrc ? (
              <img
                className="profile-page__avatar"
                src={heroSrc}
                alt=""
              />
            ) : (
              <div
                className="profile-page__avatar profile-page__avatar--placeholder"
                aria-hidden
              >
                {(user.name || user.email || "?")
                  .charAt(0)
                  .toUpperCase()}
              </div>
            )}
          </div>
          <h1 className="profile-page__title">
            Hi, {user.name || user.email}
          </h1>
        </div>

        {showExtraInfoBanner && (
          <ProfileExtraInfoBanner
            onAdd={openExtraInfoModal}
            onDismiss={() => setExtraBannerHidden(true)}
          />
        )}

        <ProfileExtraInfoDisplay profileExtra={user?.profile_extra} />

        <div className="profile-page__actions profile-page__actions--toolbar">
          <button
            type="button"
            className="profile-page__btn profile-page__btn--primary profile-page__btn--compact"
            onClick={openModal}
          >
            Edit settings
          </button>
          <button
            type="button"
            className="profile-page__btn profile-page__btn--ghost profile-page__btn--compact"
            onClick={userLogout}
          >
            Log out
          </button>
        </div>
        <section className="profile-page__section profile-page__section--friends">
          <h2 className="profile-page__section-heading profile-page__section-heading--friends">
            Your Friends
          </h2>
          <div className="profile-page__friend-search">
            <input
              type="text"
              value={friendSearch}
              onChange={(e) => setFriendSearch(e.target.value)}
              placeholder="Search by name or email"
            />
            {friendSearchResults.length > 0 && (
              <div className="profile-page__friend-results-scroll">
                <ul className="profile-page__friend-results">
                  {friendSearchResults.map((candidate) => (
                    <li key={candidate.id} className="profile-page__friend-row">
                      <div className="profile-page__friend-row-main">
                        {displayAvatarSrc(candidate) ? (
                          <img
                            className="profile-page__friend-avatar-img"
                            src={displayAvatarSrc(candidate)}
                            alt=""
                          />
                        ) : (
                          <div
                            className="profile-page__friend-avatar profile-page__friend-avatar--placeholder"
                            aria-hidden
                          >
                            {(candidate.name || candidate.email || "?")
                              .charAt(0)
                              .toUpperCase()}
                          </div>
                        )}
                        <div className="profile-page__friend-row-text">
                          <strong>{candidate.name || candidate.email || "?"}</strong>
                          {candidate.email && candidate.name ? (
                            <p>{candidate.email}</p>
                          ) : null}
                        </div>
                      </div>
                      <div className="profile-page__friend-row-action">
                        {renderFriendSearchAction(candidate)}
                      </div>
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>

          <div
            className={`profile-page__friend-columns${
              incomingRequests.length > 0 ? "" : " profile-page__friend-columns--solo"
            }`}
          >
            {incomingRequests.length > 0 && (
            <div>
              <ProfileSubsectionLabel icon="fa-solid fa-inbox" variant="requests">
                Friend requests
              </ProfileSubsectionLabel>
                <ul className="profile-page__friend-results">
                  {incomingRequests.map((req) => (
                    <li key={req.id} className="profile-page__friend-row">
                      <div className="profile-page__friend-row-main">
                        {displayAvatarSrc(req) ? (
                          <img
                            className="profile-page__friend-avatar-img"
                            src={displayAvatarSrc(req)}
                            alt=""
                          />
                        ) : (
                          <div
                            className="profile-page__friend-avatar profile-page__friend-avatar--placeholder"
                            aria-hidden
                          >
                            {(req.name || req.email || "?").charAt(0).toUpperCase()}
                          </div>
                        )}
                        <div className="profile-page__friend-row-text">
                          <strong>{req.name || req.email || "?"}</strong>
                          {req.email && req.name ? <p>{req.email}</p> : null}
                        </div>
                      </div>
                      <div className="profile-page__friend-row-action profile-page__friend-actions">
                        <button
                          type="button"
                          disabled={friendBusy}
                          onClick={() => handleAcceptRequest(req)}
                        >
                          Accept
                        </button>
                        <button
                          type="button"
                          disabled={friendBusy}
                          onClick={() => handleRejectRequest(req)}
                        >
                          Reject
                        </button>
                      </div>
                    </li>
                  ))}
                </ul>
            </div>
            )}
            <div>
              <ProfileSubsectionLabel icon="fa-solid fa-user-group" variant="friends">
                Friends
              </ProfileSubsectionLabel>
              {friends.length === 0 ? (
                <p className="profile-page__empty-small">No friends yet.</p>
              ) : (
                <div className="profile-page__friends-scroll">
                  <ul className="profile-page__friends-tiles">
                    {friends.map((friend) => (
                      <li key={friend.id} className="profile-page__friend-tile-wrap">
                        <Link
                          to={`/users/${friend.id}`}
                          className="profile-page__friend-tile"
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
                              {(friend.name || friend.email || "?")
                                .charAt(0)
                                .toUpperCase()}
                            </div>
                          )}
                          <span className="profile-page__friend-tile-name">
                            <span className="profile-page__friend-tile-line">
                              {friend.name || friend.email}
                            </span>
                            {friend.name && friend.email ? (
                              <span className="profile-page__friend-tile-line profile-page__friend-tile-line--sub">
                                {friend.email}
                              </span>
                            ) : null}
                          </span>
                        </Link>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </div>
          {friendError && <p className="profile-page__error">{friendError}</p>}
        </section>

        <section className="profile-page__section profile-page__section--events">
          <div className="profile-page__events-heading-row">
            <h2 className="profile-page__section-heading profile-page__section-heading--events">
              Your Events
            </h2>
            <ProfileScheduleShareButton
              inline
              eventsByDay={eventsByDay}
              userName={user?.name || user?.email}
              avatarUrl={displayAvatarSrc(user)}
              profileExtra={user?.profile_extra}
              timeZone={timelineTimeZone}
              onSaveProfileExtra={handleSaveProfileExtra}
            />
          </div>
          <ProfileEventAddSearch
            timeZone={timelineTimeZone}
            includePastEvents={profileEventsIncludePast}
            onAfterRsvpChange={syncUserSchedule}
          />

          {hasEventsByDay &&
            eventsByDay.map(([dayKey, dayData]) => (
              <section key={dayKey} className="profile-page__group-day">
                <h3 className="profile-page__events-day-heading">{dayData.label}</h3>

                {dayData.attending.length > 0 && (
                  <div className="profile-page__status-group profile-page__status-group--attending">
                    <ProfileSubsectionLabel
                      icon="fa-solid fa-circle-check"
                      variant="attending"
                    >
                      Attending
                    </ProfileSubsectionLabel>
                    {dayData.attending.map((event, i) => (
                      <EventCard
                        key={`att-${event.id || i}`}
                        event={event}
                        timeZone={timelineTimeZone}
                        sheTheyForwardTimeline={sheTheyForwardTimeline}
                        showVenueName
                        showArtists={false}
                        onClick={() => openEvent(event.id)}
                        onAfterRsvpChange={syncUserSchedule}
                      />
                    ))}
                  </div>
                )}

                {dayData.interested.length > 0 && (
                  <div className="profile-page__status-group profile-page__status-group--interested">
                    <ProfileSubsectionLabel icon="fa-solid fa-star" variant="interested">
                      Interested
                    </ProfileSubsectionLabel>
                    <div className="profile-page__interested-grid">
                      {dayData.interested.map((event, i) => (
                        <EventCard
                          key={`int-${event.id || i}`}
                          event={event}
                          timeZone={timelineTimeZone}
                          sheTheyForwardTimeline={sheTheyForwardTimeline}
                          showVenueName
                          showArtists={false}
                          density="compact"
                          onClick={() => openEvent(event.id)}
                          onAfterRsvpChange={syncUserSchedule}
                        />
                      ))}
                    </div>
                  </div>
                )}
              </section>
            ))}

          {!hasEventsByDay && (
            <p className="profile-page__empty profile-page__empty--schedule-hint">
              When you mark events as interested or attending, they will show up here.
            </p>
          )}
        </section>
      </div>

      <EventDetailsShell
        eventId={selectedEventId}
        allEvents={allProfileEvents}
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
        allEvents={allProfileEvents}
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

      <ProfileExtraInfoModal
        isOpen={extraInfoOpen}
        onClose={closeExtraInfoModal}
        onSave={handleSaveExtraInfoModal}
        saveBusy={extraSaveBusy}
        saveError={extraSaveError}
      />

      <ModalLayout
        isOpen={isOpen}
        onClose={closeModal}
        className="edit-profile"
        header={<h3>Edit profile settings</h3>}
      >
        <div className="edit-profile-body">
          <section className="edit-profile-section" aria-labelledby="edit-profile-photo-heading">
            <h4 id="edit-profile-photo-heading" className="edit-profile-section__title">
              Profile photo
            </h4>
            <div className="profile-photo-editor profile-photo-editor--in-section">
              {modalPreview ? (
                <img
                  className="profile-photo-editor__preview"
                  src={modalPreview}
                  alt=""
                />
              ) : (
                <div
                  className="profile-photo-editor__preview profile-page__avatar--placeholder"
                  aria-hidden
                >
                  {(user.name || user.email || "?").charAt(0).toUpperCase()}
                </div>
              )}
              <div className="profile-photo-editor__actions">
                <input
                  ref={fileInputRef}
                  id="profile-avatar-input"
                  type="file"
                  accept="image/*"
                  className="profile-photo-editor__file"
                  onChange={onAvatarFileChange}
                />
                <label
                  htmlFor="profile-avatar-input"
                  className="profile-photo-editor__file-trigger"
                >
                  Choose a photo
                </label>
                <p className="profile-photo-editor__hint">
                  Square photos look best. Max 8MB. Upload saves immediately.
                </p>
                {uploadError && (
                  <p className="profile-photo-editor__error" role="alert">
                    {uploadError}
                  </p>
                )}
                <button
                  type="button"
                  className="profile-photo-editor__upload"
                  disabled={!avatarFile || uploadBusy}
                  onClick={handleUploadAvatar}
                >
                  {uploadBusy ? "Uploading…" : "Upload photo"}
                </button>
              </div>
            </div>
          </section>

          <section className="edit-profile-section" aria-labelledby="edit-profile-account-heading">
            <h4 id="edit-profile-account-heading" className="edit-profile-section__title">
              Account
            </h4>
            <div className="profile-account-editor profile-account-editor--fields-only">
              <p className="profile-account-editor__label">Display name</p>
              <input
                type="text"
                className="profile-account-editor__input"
                value={editName}
                onChange={(e) => setEditName(e.target.value)}
                autoComplete="name"
                maxLength={120}
              />
              <p className="profile-account-editor__label">Email</p>
              <input
                type="email"
                className="profile-account-editor__input"
                value={editEmail}
                onChange={(e) => setEditEmail(e.target.value)}
                autoComplete="email"
              />
            </div>
          </section>

          <section
            className="edit-profile-section"
            aria-labelledby="edit-profile-extra-heading"
          >
            <h4 id="edit-profile-extra-heading" className="edit-profile-section__title">
              Extra profile info
            </h4>
            <ProfileExtraInfoFields
              values={editExtra}
              onChange={setEditExtra}
              disabled={accountBusy}
              idPrefix="profile-edit-extra"
            />
          </section>
        </div>

        <div className="edit-profile-footer">
          {accountError && (
            <p className="profile-account-editor__error" role="alert">
              {accountError}
            </p>
          )}
          <button
            type="button"
            className="edit-profile-footer__save profile-page__btn profile-page__btn--primary"
            disabled={accountBusy}
            onClick={handleSaveAccount}
          >
            {accountBusy ? "Saving…" : "Save changes"}
          </button>
          <p className="edit-profile-footer__note">
            Saves name, email, and extra profile info. Photo uploads separately above.
          </p>
        </div>

      </ModalLayout>
    </>
  );
}

export default Profile;
