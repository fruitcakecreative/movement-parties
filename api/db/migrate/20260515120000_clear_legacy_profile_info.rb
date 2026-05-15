# Legacy users.profile_info held free-text bios (e.g. "Techno lover").
# Profile extra fields use JSON in the same column; clear non-JSON values so everyone starts blank.
class ClearLegacyProfileInfo < ActiveRecord::Migration[7.1]
  def up
    User.where.not(profile_info: nil).find_each do |user|
      info = user.profile_info.to_s.strip
      next if info.start_with?("{")
      next if info.blank?

      user.update_column(:profile_info, nil)
    end
  end

  def down
    # Non-reversible — legacy free-text was not mapped to profile_extra fields.
  end
end
