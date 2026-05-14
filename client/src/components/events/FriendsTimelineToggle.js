import React from 'react';

/**
 * Timeline filter: only events where at least one accepted friend is attending or interested.
 */
function FriendsTimelineToggle({ enabled, onChange }) {
  return (
    <div className="she-they-forward-rail friends-timeline-rail">
      <div className={`friends-timeline-card ${enabled ? 'friends-timeline-card--on' : ''}`}>
        <div className="friends-timeline-card__head">
          <div className="friends-timeline-card__text">
            <h3 className="friends-timeline-card__title">Friends on lineup</h3>
            <p className="friends-timeline-card__copy">
              Show only events your friends are attending or interested in.
            </p>
          </div>
          <button
            type="button"
            role="switch"
            aria-checked={enabled}
            aria-label={
              enabled
                ? 'Turn off friends-only filter'
                : 'Turn on friends-only filter'
            }
            className={`she-they-forward-switch ${enabled ? 'she-they-forward-switch--on' : 'she-they-forward-switch--off'}`}
            onClick={() => onChange(!enabled)}
          >
            <span
              className={`she-they-forward-switch__track ${enabled ? 'she-they-forward-switch__track--on' : ''}`}
              aria-hidden
            >
              <span className="she-they-forward-switch__thumb" />
            </span>
          </button>
        </div>
      </div>
    </div>
  );
}

export default FriendsTimelineToggle;
