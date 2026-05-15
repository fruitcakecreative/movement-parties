import { useState } from 'react';
import {
  downloadScheduleShareBlob,
  generateScheduleShareImage,
} from '../utils/generateScheduleShareImage';
import { hasAnyProfileExtra } from '../utils/profileExtraInfo';
import { trackPlausible } from '../utils/plausible';
import ProfileScheduleShareModal from './profile/ProfileScheduleShareModal';

function ProfileScheduleShareButton({
  eventsByDay,
  userName,
  avatarUrl,
  profileExtra,
  timeZone,
  onSaveProfileExtra,
  disabled = false,
  inline = false,
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [saveBusy, setSaveBusy] = useState(false);

  const hasEvents = eventsByDay?.length > 0;

  const runGenerate = async (profileExtraOverride) => {
    const extraForImage = profileExtraOverride ?? profileExtra;
    setBusy(true);
    setError(null);
    try {
      const blob = await generateScheduleShareImage({
        eventsByDay,
        userName,
        avatarUrl,
        profileExtra: extraForImage,
        timeZone,
      });
      downloadScheduleShareBlob(blob);
      trackPlausible('Schedule Share Image', { action: 'download' });
    } catch (err) {
      console.error(err);
      setError('Could not create image. Try again.');
    } finally {
      setBusy(false);
    }
  };

  const startGenerateFlow = () => {
    if (!hasEvents || busy) return;
    if (hasAnyProfileExtra(profileExtra)) {
      runGenerate();
      return;
    }
    setModalOpen(true);
  };

  const handleModalGenerate = (profileExtraOverride) => {
    runGenerate(profileExtraOverride);
  };

  const handleSaveProfileExtra = async (extra) => {
    setSaveBusy(true);
    try {
      await onSaveProfileExtra?.(extra);
    } finally {
      setSaveBusy(false);
    }
  };

  if (!hasEvents) return null;

  const wrapClass = inline
    ? 'profile-schedule-share profile-schedule-share--inline'
    : 'profile-schedule-share';

  return (
    <>
      <div className={wrapClass}>
        <button
          type="button"
          className="profile-page__btn profile-page__btn--primary profile-page__btn--compact profile-schedule-share__btn"
          disabled={disabled || busy}
          onClick={startGenerateFlow}
        >
          {busy ? 'Creating…' : 'Generate shareable schedule image'}
        </button>
        {error && (
          <p className="profile-page__error profile-schedule-share__error" role="alert">
            {error}
          </p>
        )}
      </div>

      <ProfileScheduleShareModal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        onSaveProfileExtra={handleSaveProfileExtra}
        onGenerate={handleModalGenerate}
        saveBusy={saveBusy}
      />
    </>
  );
}

export default ProfileScheduleShareButton;
