import React, { useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useUserEvents } from "../../context/UserEventsContext";

/**
 * Interested (star) + Attending (check) — one status per event (API enum).
 * variant: compact (icons only), pills (labels), card (footer strip).
 */
function friendCountLabel(count, kind) {
  if (count == null || count < 1) return null;
  const n = count;
  const friendWord = n === 1 ? "friend" : "friends";
  if (kind === "interested") return `${n} ${friendWord} interested`;
  return `${n} ${friendWord} attending`;
}

function EventStatusControls({
  eventId,
  variant = "compact",
  className = "",
  showTapLabel = false,
  tapLabelDurationMs = 1000,
  friendsInterestedCount,
  friendsAttendingCount,
}) {
  const navigate = useNavigate();
  const {
    getStatus,
    toggleInterested,
    toggleAttending,
    isAuthenticated,
    isPending,
  } = useUserEvents();

  const numericEventId = Number(eventId);
  const status = eventId == null ? null : getStatus(numericEventId);
  const busy = eventId == null ? false : isPending(numericEventId);
  const [tapLabel, setTapLabel] = useState({ text: "", kind: "" });
  const tapTimerRef = useRef(null);

  const triggerTapLabel = (text, kind) => {
    if (!showTapLabel) return;
    setTapLabel({ text, kind });
    if (tapTimerRef.current) window.clearTimeout(tapTimerRef.current);
    tapTimerRef.current = window.setTimeout(() => {
      setTapLabel({ text: "", kind: "" });
      tapTimerRef.current = null;
    }, tapLabelDurationMs);
  };

  useEffect(() => {
    return () => {
      if (tapTimerRef.current) window.clearTimeout(tapTimerRef.current);
    };
  }, []);

  if (eventId == null) return null;

  const onInterested = (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (!isAuthenticated) {
      navigate("/login");
      return;
    }
    toggleInterested(numericEventId);
    triggerTapLabel(interestedOn ? "not interested" : "interested", "interested");
  };

  const onAttending = (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (!isAuthenticated) {
      navigate("/login");
      return;
    }
    toggleAttending(numericEventId);
    triggerTapLabel(attendingOn ? "not attending" : "attending", "attending");
  };

  const interestedOn = status === "interested";
  const attendingOn = status === "attending";

  if (variant === "pills") {
    const interestedHint = friendCountLabel(friendsInterestedCount, "interested");
    const attendingHint = friendCountLabel(friendsAttendingCount, "attending");
    return (
      <div
        className={`event-status event-status--pills ${className}`.trim()}
        onClick={(e) => e.stopPropagation()}
        role="group"
        aria-label="Your plan for this event"
      >
        <div className="event-status__pill-row">
          <button
            type="button"
            className={`event-status__pill event-status__pill--interested${
              interestedOn ? " event-status__pill--active" : ""
            }`}
            onClick={onInterested}
            disabled={busy}
            aria-pressed={interestedOn}
            aria-label={interestedOn ? "Remove interested" : "Mark interested"}
          >
            <i
              className={interestedOn ? "fa-solid fa-star" : "fa-regular fa-star"}
              aria-hidden
            />
            <span>Interested</span>
          </button>
          {interestedHint && (
            <>
              <span className="event-status__friend-sep" aria-hidden>
                –
              </span>
              <span className="event-status__friend-hint">{interestedHint}</span>
            </>
          )}
        </div>
        <div className="event-status__pill-row">
          <button
            type="button"
            className={`event-status__pill event-status__pill--attending${
              attendingOn ? " event-status__pill--active" : ""
            }`}
            onClick={onAttending}
            disabled={busy}
            aria-pressed={attendingOn}
            aria-label={attendingOn ? "Remove attending" : "Mark attending"}
          >
            <i
              className={
                attendingOn ? "fa-solid fa-circle-check" : "fa-regular fa-circle-check"
              }
              aria-hidden
            />
            <span>Attending</span>
          </button>
          {attendingHint && (
            <>
              <span className="event-status__friend-sep" aria-hidden>
                –
              </span>
              <span className="event-status__friend-hint">{attendingHint}</span>
            </>
          )}
        </div>
      </div>
    );
  }

  /* compact + card — optional friend hints (same line as each icon, smaller text) */
  const interestedHintCompact = friendCountLabel(friendsInterestedCount, "interested");
  const attendingHintCompact = friendCountLabel(friendsAttendingCount, "attending");

  return (
    <div
      className={`event-status event-status--compact event-status--${variant} ${className}`.trim()}
      onClick={(e) => e.stopPropagation()}
      role="group"
      aria-label="Your plan for this event"
    >
      <div className="event-status__compact-hint-row">
        <span className="event-status__icon-wrap">
          <button
            type="button"
            className={`event-status__icon event-status__icon--interested${
              interestedOn ? " event-status__icon--on" : ""
            }`}
            onClick={onInterested}
            disabled={busy}
            aria-pressed={interestedOn}
            title={interestedOn ? "Remove interested" : "Interested"}
            aria-label={interestedOn ? "Remove interested" : "Mark interested"}
          >
            <i
              className={interestedOn ? "fa-solid fa-star" : "fa-regular fa-star"}
              aria-hidden
            />
          </button>
          {showTapLabel && tapLabel.kind === "interested" && tapLabel.text && (
            <span className="event-status__tap-label" aria-live="polite">
              {tapLabel.text}
            </span>
          )}
        </span>
        {interestedHintCompact && (
          <>
            <span className="event-status__friend-sep event-status__friend-sep--compact" aria-hidden>
              –
            </span>
            <span className="event-status__friend-hint event-status__friend-hint--compact">
              {interestedHintCompact}
            </span>
          </>
        )}
      </div>
      <div className="event-status__compact-hint-row">
        <span className="event-status__icon-wrap">
          <button
            type="button"
            className={`event-status__icon event-status__icon--attending${
              attendingOn ? " event-status__icon--on" : ""
            }`}
            onClick={onAttending}
            disabled={busy}
            aria-pressed={attendingOn}
            title={attendingOn ? "Remove attending" : "Attending"}
            aria-label={attendingOn ? "Remove attending" : "Mark attending"}
          >
            <i
              className={
                attendingOn ? "fa-solid fa-circle-check" : "fa-regular fa-circle-check"
              }
              aria-hidden
            />
          </button>
          {showTapLabel && tapLabel.kind === "attending" && tapLabel.text && (
            <span className="event-status__tap-label" aria-live="polite">
              {tapLabel.text}
            </span>
          )}
        </span>
        {attendingHintCompact && (
          <>
            <span className="event-status__friend-sep event-status__friend-sep--compact" aria-hidden>
              –
            </span>
            <span className="event-status__friend-hint event-status__friend-hint--compact">
              {attendingHintCompact}
            </span>
          </>
        )}
      </div>
    </div>
  );
}

export default EventStatusControls;
