function ProfileSubsectionLabel({ icon, children, variant = 'default' }) {
  return (
    <h3
      className={`profile-page__label-heading profile-page__label-heading--${variant}`.trim()}
    >
      <i className={icon} aria-hidden />
      <span>{children}</span>
    </h3>
  );
}

export default ProfileSubsectionLabel;
