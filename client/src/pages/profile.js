import { useEffect, useMemo, useRef, useState } from "react";
import { Link } from "react-router-dom";
import ModalLayout from "../timeline/components/modals/ModalLayout";
import MiniProgramBox from "../timeline/components/MiniProgramBox";

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
} from "../services/api";
import { FriendCountsProvider } from "../context/FriendCountsContext";
import { getSortedEventDayEntries } from "../utils/profileEventsByDay";

function Profile() {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [userEvents, setUserEvents] = useState({});
  const [isOpen, setIsOpen] = useState(false);
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

  const fileInputRef = useRef(null);

  const openModal = () => {
    document.body.style.overflow = "hidden";
    setUploadError(null);
    setIsOpen(true);
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
      await sendFriendRequest({ user_id: candidate.id, username: candidate.username });
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
        <p className="profile-page__empty">
          You need to sign in to view your profile.{" "}
          <a href="/login">Sign in</a>
        </p>
      </div>
    );
  }

  if (!user || !profile) return null;

  const heroSrc = displayAvatarSrc(user);
  const modalPreview = localPreview || heroSrc;

  return (
    <>
      <div className="profile-page">
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
                {(user.name || user.username || user.email || "?")
                  .charAt(0)
                  .toUpperCase()}
              </div>
            )}
          </div>
          <h1 className="profile-page__title">
            Hi, {user.name || user.username || user.email}
          </h1>
        </div>

        <div className="profile-page__actions">
          <button
            type="button"
            className="profile-page__btn profile-page__btn--primary"
            onClick={openModal}
          >
            Edit profile settings
          </button>
          <button
            type="button"
            className="profile-page__btn profile-page__btn--ghost"
            onClick={userLogout}
          >
            Log out
          </button>
        </div>
        <section className="profile-page__section">
          <h2 className="profile-page__section-title">Friends</h2>
          <div className="profile-page__friend-search">
            <input
              type="text"
              value={friendSearch}
              onChange={(e) => setFriendSearch(e.target.value)}
              placeholder="Search by name, username, or email"
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
                            {(candidate.name || candidate.username || "?")
                              .charAt(0)
                              .toUpperCase()}
                          </div>
                        )}
                        <div className="profile-page__friend-row-text">
                          <strong>{candidate.name || candidate.username}</strong>
                          <p>@{candidate.username}</p>
                          {candidate.email && <p>{candidate.email}</p>}
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

          <div className="profile-page__friend-columns">
            <div>
              <h3 className="profile-page__subsection-title">Requests</h3>
              {incomingRequests.length === 0 ? (
                <p className="profile-page__empty-small">No incoming requests.</p>
              ) : (
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
                            {(req.name || req.username || "?").charAt(0).toUpperCase()}
                          </div>
                        )}
                        <div className="profile-page__friend-row-text">
                          <strong>{req.name || req.username}</strong>
                          <p>@{req.username}</p>
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
              )}
            </div>
            <div>
              <h3 className="profile-page__subsection-title">Friends</h3>
              {friends.length === 0 ? (
                <p className="profile-page__empty-small">No friends yet.</p>
              ) : (
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
                            {(friend.name || friend.username || "?")
                              .charAt(0)
                              .toUpperCase()}
                          </div>
                        )}
                        <span className="profile-page__friend-tile-name">
                          {friend.name || friend.username}
                        </span>
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          </div>
          {friendError && <p className="profile-page__error">{friendError}</p>}
        </section>

        {hasEventsByDay && (
          <FriendCountsProvider eventIds={profileEventIdsForCounts}>
            {eventsByDay.map(([dayKey, dayData]) => (
              <section key={dayKey} className="profile-page__group-day">
                <h2 className="profile-page__section-title">{dayData.label}</h2>

                {dayData.attending.length > 0 && (
                  <div className="profile-page__status-group profile-page__status-group--attending">
                    <h3 className="profile-page__subsection-title">Attending</h3>
                    {dayData.attending.map((event, i) => (
                      <MiniProgramBox
                        key={`att-${event.id || i}`}
                        event={event}
                        onClick={() => {}}
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
                        onClick={() => {}}
                      />
                    ))}
                  </div>
                )}
              </section>
            ))}
          </FriendCountsProvider>
        )}

        {!hasEventsByDay && (
            <p className="profile-page__empty">
              When you mark events as interested or attending, they will show up
              here.
            </p>
          )}
      </div>

      <ModalLayout
        isOpen={isOpen}
        onClose={closeModal}
        className="edit-profile"
        header={<h3>Edit profile settings</h3>}
      >
        <div className="profile-photo-editor">
          <p className="profile-photo-editor__label">Profile photo</p>
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
            Square photos look best. Max 8MB.
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
            {uploadBusy ? "Uploading…" : "Save photo"}
          </button>
        </div>
      </ModalLayout>
    </>
  );
}

export default Profile;
