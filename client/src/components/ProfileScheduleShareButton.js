import { useState } from 'react';
import {
  downloadScheduleShareBlob,
  generateScheduleShareImage,
  shareScheduleShareBlob,
} from '../utils/generateScheduleShareImage';
import { trackPlausible } from '../utils/plausible';

function ProfileScheduleShareButton({
  eventsByDay,
  userName,
  timeZone,
  disabled = false,
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  const hasEvents = eventsByDay?.length > 0;
  const siteTitle = process.env.REACT_APP_PAGE_TITLE || 'Movement Parties';

  const handleGenerate = async (mode) => {
    if (!hasEvents || busy) return;
    setBusy(true);
    setError(null);
    try {
      const blob = await generateScheduleShareImage({
        eventsByDay,
        userName,
        timeZone,
        siteTitle,
      });
      const title = `${userName || 'My'} schedule — ${siteTitle}`;
      if (mode === 'share') {
        const shared = await shareScheduleShareBlob(blob, title);
        if (!shared) {
          downloadScheduleShareBlob(blob);
        }
        trackPlausible('Schedule Share Image', { action: shared ? 'share' : 'download' });
      } else {
        downloadScheduleShareBlob(blob);
        trackPlausible('Schedule Share Image', { action: 'download' });
      }
    } catch (err) {
      console.error(err);
      setError('Could not create image. Try again.');
    } finally {
      setBusy(false);
    }
  };

  const canNativeShare =
    typeof navigator !== 'undefined' &&
    typeof navigator.share === 'function';

  if (!hasEvents) return null;

  return (
    <div className="profile-schedule-share hide">
      <p className="profile-schedule-share__label">Share your lineup</p>
      <div className="profile-schedule-share__actions">
        <button
          type="button"
          className="profile-page__btn profile-page__btn--primary profile-page__btn--compact profile-schedule-share__btn"
          disabled={disabled || busy}
          onClick={() => handleGenerate('download')}
        >
          {busy ? 'Creating…' : 'Download schedule image'}
        </button>
        {canNativeShare && (
          <button
            type="button"
            className="profile-page__btn profile-page__btn--ghost profile-page__btn--compact profile-schedule-share__btn"
            disabled={disabled || busy}
            onClick={() => handleGenerate('share')}
          >
            Share
          </button>
        )}
      </div>
      {error && (
        <p className="profile-page__error" role="alert">
          {error}
        </p>
      )}
    </div>
  );
}

export default ProfileScheduleShareButton;
