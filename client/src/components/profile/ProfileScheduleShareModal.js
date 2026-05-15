import { useEffect, useState } from 'react';
import ModalLayout from '../../timeline/components/modals/ModalLayout';
import ProfileExtraInfoFields from './ProfileExtraInfoFields';
import { emptyProfileExtra } from '../../utils/profileExtraInfo';

function ProfileScheduleShareModal({
  isOpen,
  onClose,
  onSaveProfileExtra,
  onGenerate,
  saveBusy = false,
}) {
  const [step, setStep] = useState('empty-prompt');
  const [draftExtra, setDraftExtra] = useState(emptyProfileExtra);

  useEffect(() => {
    if (!isOpen) return;
    setDraftExtra(emptyProfileExtra());
    setStep('empty-prompt');
  }, [isOpen]);

  const handleClose = () => onClose?.();

  const handleSkip = () => {
    onGenerate?.();
    handleClose();
  };

  const handleSaveAndGenerate = async () => {
    await onSaveProfileExtra?.(draftExtra);
    onGenerate?.(draftExtra);
    handleClose();
  };

  if (!isOpen) return null;

  const isAddFields = step === 'add-fields';

  return (
    <ModalLayout
      isOpen={isOpen}
      onClose={handleClose}
      className="profile-share-modal"
      header={<h3>{isAddFields ? 'Extra profile info' : 'Add profile info?'}</h3>}
    >
      <div className="profile-share-modal__body">
        {isAddFields ? (
          <ProfileExtraInfoFields
            values={draftExtra}
            onChange={setDraftExtra}
            disabled={saveBusy}
            idPrefix="share-extra"
          />
        ) : (
          <p className="profile-share-modal__lead">
            Add optional details for your schedule image, or share your lineup only.
          </p>
        )}
      </div>

      <div className="profile-share-modal__footer">
        {isAddFields ? (
          <>
            <button
              type="button"
              className="profile-page__btn profile-page__btn--primary profile-share-modal__btn"
              disabled={saveBusy}
              onClick={handleSaveAndGenerate}
            >
              {saveBusy ? 'Saving…' : 'Save & create image'}
            </button>
            <button
              type="button"
              className="profile-page__btn profile-page__btn--ghost profile-share-modal__btn"
              onClick={() => setStep('empty-prompt')}
            >
              Back
            </button>
          </>
        ) : (
          <>
            <button
              type="button"
              className="profile-page__btn profile-page__btn--primary profile-share-modal__btn"
              onClick={() => setStep('add-fields')}
            >
              Add info
            </button>
            <button
              type="button"
              className="profile-page__btn profile-page__btn--ghost profile-share-modal__btn"
              onClick={handleSkip}
            >
              Share lineup only
            </button>
          </>
        )}
      </div>
    </ModalLayout>
  );
}

export default ProfileScheduleShareModal;
