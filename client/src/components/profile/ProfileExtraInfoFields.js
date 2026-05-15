import { PROFILE_EXTRA_FIELDS, emptyProfileExtra } from '../../utils/profileExtraInfo';

function ProfileExtraInfoFields({
  values,
  onChange,
  idPrefix = 'profile-extra',
  disabled = false,
}) {
  const v =
    values && typeof values === 'object'
      ? { ...emptyProfileExtra(), ...values }
      : emptyProfileExtra();

  const set = (key, next) => {
    onChange?.({ ...v, [key]: next });
  };

  return (
    <div className="profile-extra-fields">
      {PROFILE_EXTRA_FIELDS.map(
        ({ key, label, placeholder, maxLength, inputType = 'text', rows }) => {
          const fieldId = `${idPrefix}-${key}`;
          const common = {
            id: fieldId,
            className: 'profile-extra-fields__input',
            value: v[key],
            onChange: (e) => set(key, e.target.value),
            placeholder,
            disabled,
            maxLength,
          };

          return (
            <div key={key} className="profile-extra-fields__row">
              <label className="profile-extra-fields__label" htmlFor={fieldId}>
                {label}
              </label>
              {inputType === 'textarea' ? (
                <textarea {...common} rows={rows ?? 3} />
              ) : (
                <input {...common} type="text" autoComplete="off" />
              )}
            </div>
          );
        }
      )}
    </div>
  );
}

export default ProfileExtraInfoFields;
