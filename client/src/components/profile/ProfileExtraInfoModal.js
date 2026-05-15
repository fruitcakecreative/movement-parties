import { useEffect, useState } from 'react';
import ModalLayout from '../../timeline/components/modals/ModalLayout';
import ProfileExtraInfoFields from './ProfileExtraInfoFields';
import { emptyProfileExtra } from '../../utils/profileExtraInfo';

function ProfileExtraInfoModal({
  isOpen,
  onClose,
  onSave,
  saveBusy = false,
  saveError = null,
}) {
  const [draft, setDraft] = useState(emptyProfileExtra);

  useEffect(() => {
    if (!isOpen) return;
    setDraft(emptyProfileExtra());
  }, [isOpen]);

  const handleSave = () => onSave?.(draft);

  if (!isOpen) return null;

  return (
    <ModalLayout
      isOpen={isOpen}
      onClose={onClose}
      className="profile-share-modal profile-extra-info-modal"
      header={<h3>Extra profile info</h3>}
    >
      <div className="profile-share-modal__body">
        <ProfileExtraInfoFields
          values={draft}
          onChange={setDraft}
          disabled={saveBusy}
          idPrefix="banner-extra"
        />
      </div>

      <div className="profile-share-modal__footer">
        {saveError && (
          <p className="profile-account-editor__error" role="alert">
            {saveError}
          </p>
        )}
        <button
          type="button"
          className="profile-page__btn profile-page__btn--primary profile-share-modal__btn"
          disabled={saveBusy}
          onClick={handleSave}
        >
          {saveBusy ? 'Saving…' : 'Save'}
        </button>
        <button
          type="button"
          className="profile-page__btn profile-page__btn--ghost profile-share-modal__btn"
          disabled={saveBusy}
          onClick={onClose}
        >
          Cancel
        </button>
      </div>
    </ModalLayout>
  );
}

export default ProfileExtraInfoModal;
