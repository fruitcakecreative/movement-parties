import { Fragment } from 'react';
import {
  WEEKEND_BADGE_ICONS,
  formatMovementWeekendLabel,
  getFilledProfileExtraEntries,
  getWeekendBadgeTier,
  parseWeekendsAttendedCount,
} from '../../utils/profileExtraInfo';

const TIP_KEY = 'movement_pro_tip';
const WEEKENDS_KEY = 'weekends_attended';

function WeekendBadge({ value }) {
  const count = parseWeekendsAttendedCount(value);
  const tier = getWeekendBadgeTier(count);
  const label = count != null ? formatMovementWeekendLabel(count) : null;

  if (!tier || !label) {
    return (
      <span className="profile-extra-display__fact">
        <span className="profile-extra-display__label">Weekends</span>
        <span className="profile-extra-display__value">{value}</span>
      </span>
    );
  }

  return (
    <span
      className={`profile-extra-display__weekend-badge profile-extra-display__weekend-badge--${tier}`}
      title={label}
    >
      <i className={WEEKEND_BADGE_ICONS[tier]} aria-hidden />
      <span>{label}</span>
    </span>
  );
}

function ProfileExtraInfoDisplay({ profileExtra, className = '' }) {
  const rows = getFilledProfileExtraEntries(profileExtra);
  if (!rows.length) return null;

  const weekendsRow = rows.find((row) => row.key === WEEKENDS_KEY);
  const tipRow = rows.find((row) => row.key === TIP_KEY);
  const factRows = rows.filter(
    (row) => row.key !== TIP_KEY && row.key !== WEEKENDS_KEY
  );

  return (
    <section
      className={`profile-extra-display ${className}`.trim()}
      aria-label="Profile details"
    >
      {weekendsRow && (
        <div className="profile-extra-display__weekend-wrap">
          <WeekendBadge value={weekendsRow.value} />
        </div>
      )}

      {factRows.length > 0 && (
        <div className="profile-extra-display__facts" role="list">
          {factRows.map((row, index) => (
            <Fragment key={row.key}>
              {index > 0 && (
                <span className="profile-extra-display__sep" aria-hidden>
                  ·
                </span>
              )}
              <span className="profile-extra-display__fact" role="listitem">
                <span className="profile-extra-display__label">{row.shortLabel}</span>
                <span className="profile-extra-display__value">{row.value}</span>
              </span>
            </Fragment>
          ))}
        </div>
      )}

      {tipRow && (
        <p className="profile-extra-display__tip">
          <span className="profile-extra-display__label">{tipRow.shortLabel}</span>
          <span className="profile-extra-display__value">{tipRow.value}</span>
        </p>
      )}
    </section>
  );
}

export default ProfileExtraInfoDisplay;
