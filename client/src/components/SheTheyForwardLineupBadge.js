import React from 'react';
import { sheTheyForwardLineupPercent, sheTheyLineupPctBadgeClassName } from '../utils/pronounDisplay';

/** Pill showing “N% She/They artists” only when she/they mode is on and pronoun data exists. */
function SheTheyForwardLineupBadge({
  artists,
  className = '',
  sheTheyForwardTimeline = false,
}) {
  if (!sheTheyForwardTimeline) return null;
  const pct = sheTheyForwardLineupPercent(artists);
  if (pct == null) return null;
  return (
    <span
      className={`${sheTheyLineupPctBadgeClassName(pct)} ${className}`.trim()}
      title="Share of billed artists with pronouns on file who are not he-presenting"
    >
      {pct}% She/They artists
    </span>
  );
}

export default SheTheyForwardLineupBadge;
