import { dismissProfileExtraBanner } from '../../utils/profileExtraInfo';

function ProfileExtraInfoBanner({ onAdd, onDismiss }) {
  const handleDismiss = () => {
    dismissProfileExtraBanner();
    onDismiss?.();
  };

  return (
    <div className="profile-extra-banner" role="status">
      <button
        type="button"
        className="profile-extra-banner__close"
        onClick={handleDismiss}
        aria-label="Dismiss — don't add profile info"
      >
        ×
      </button>
      <p className="profile-extra-banner__text">
        Add extra profile info for your schedule share image and public profile.
      </p>
      <button
        type="button"
        className="profile-page__btn profile-page__btn--primary profile-page__btn--compact profile-extra-banner__cta"
        onClick={onAdd}
      >
        Add extra profile info
      </button>
    </div>
  );
}

export default ProfileExtraInfoBanner;
