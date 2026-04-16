import React from 'react';

const COPY =
  'Turn this on and all the men will magically disappear. In an industry this male-dominated, this is a small way to highlight the badass women, non-binary, and gender-nonconforming artists.';

/**
 * “No Boys Club” mode — standalone from the filter pill row.
 * Optional second row: only list events whose lineup is at least 50% she/they-forward (shown when main is on).
 */
function SheTheyForwardToggle({
  enabled,
  onEnabledChange,
  over50Only = false,
  onOver50Change,
}) {
  return (
    <div className="she-they-forward-rail">
      <div className={`she-they-forward-card ${enabled ? 'she-they-forward-card--on' : ''}`}>
        <div className="she-they-forward-card__head">
          <h3 className="she-they-forward-card__title">No Boys Club</h3>
          <button
            type="button"
            role="switch"
            aria-checked={enabled}
            aria-label={enabled ? 'Turn off No Boys Club' : 'Turn on No Boys Club'}
            className={`she-they-forward-switch ${enabled ? 'she-they-forward-switch--on' : 'she-they-forward-switch--off'}`}
            onClick={() => onEnabledChange(!enabled)}
          >
            <span
              className={`she-they-forward-switch__track ${enabled ? 'she-they-forward-switch__track--on' : ''}`}
              aria-hidden
            >
              <span className="she-they-forward-switch__thumb" />
            </span>
          </button>
        </div>
        <p className="she-they-forward-card__copy">{COPY}</p>

        {enabled && typeof onOver50Change === 'function' && (
          <div className="she-they-forward-subtoggle">
            <div className="she-they-forward-subtoggle__row">
              <span className="she-they-forward-subtoggle__label" id="she-they-over50-label">
                Only show events with an over 50% she/they lineup
              </span>
              <button
                type="button"
                role="switch"
                aria-checked={over50Only}
                aria-labelledby="she-they-over50-label"
                aria-label={
                  over50Only
                    ? 'Turn off at least 50 percent she-they lineup filter'
                    : 'Turn on at least 50 percent she-they lineup filter'
                }
                className={`she-they-forward-switch she-they-forward-switch--sub ${over50Only ? 'she-they-forward-switch--on' : 'she-they-forward-switch--off'}`}
                onClick={() => onOver50Change(!over50Only)}
              >
                <span
                  className={`she-they-forward-switch__track ${over50Only ? 'she-they-forward-switch__track--on' : ''}`}
                  aria-hidden
                >
                  <span className="she-they-forward-switch__thumb" />
                </span>
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default SheTheyForwardToggle;
