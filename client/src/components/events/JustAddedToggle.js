import React from 'react';

/**
 * Filter: events whose `created_at` is within the last 7 days.
 * Sits below the No Boys Club card in the events toolbar.
 */
function JustAddedToggle({ enabled, onChange }) {
  return (
    <div className="she-they-forward-rail just-added-rail">
      <div className={`just-added-card ${enabled ? 'just-added-card--on' : ''}`}>
        <div className="just-added-card__head">
          <div className="just-added-card__text">
            <h3 className="just-added-card__title">JUST ADDED</h3>
            <p className="just-added-card__copy">
              Toggle to see events added in the last 7 days.
            </p>
          </div>
          <button
            type="button"
            role="switch"
            aria-checked={enabled}
            aria-label={enabled ? 'Turn off JUST ADDED filter' : 'Turn on JUST ADDED filter'}
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

export default JustAddedToggle;
