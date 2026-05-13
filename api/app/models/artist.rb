class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  validates :name, presence: true
  has_many :artist_events, dependent: :destroy
  has_many :events, through: :artist_events
  has_many :artist_aliases, dependent: :destroy
  # genre validation removed or made optional

  # Same key as used in find_or_create_by_canonical_name! accent fold + spacing (not full ImportHelpers.normalize_text).
  def self.normalize_import_name_key(name)
    stripped = name.to_s.strip
    return "" if stripped.blank?

    ImportHelpers.fold_accents(stripped).downcase.gsub(/\s+/, " ").strip
  end

  def self.find_by_name_case_insensitive(name)
    base = name.to_s.strip
    return nil if base.blank?

    where("LOWER(TRIM(name)) = ?", base.downcase).first
  end

  # Move all lineup rows from `merge` onto `keeper`, drop duplicate event links, then delete `merge`.
  # Optionally fills blank keeper pronouns / genre_id and bumps ra_followers when merge is higher.
  # @return [Hash] :reassigned, :duplicate_joins_removed, :dry_run
  def self.merge_into!(keeper, merge, dry_run: false)
    raise ArgumentError, "keeper and merge must differ" if keeper.id == merge.id

    stats = { reassigned: 0, duplicate_joins_removed: 0, dry_run: dry_run }
    keeper_event_ids = keeper.artist_events.pluck(:event_id).to_set

    if dry_run
      merge.artist_events.find_each do |ae|
        if keeper_event_ids.include?(ae.event_id)
          stats[:duplicate_joins_removed] += 1
        else
          stats[:reassigned] += 1
          keeper_event_ids.add(ae.event_id)
        end
      end
      return stats
    end

    transaction do
      keeper_event_ids = keeper.artist_events.pluck(:event_id).to_set

      merge.artist_events.find_each do |ae|
        if keeper_event_ids.include?(ae.event_id)
          stats[:duplicate_joins_removed] += 1
          ae.destroy!
        else
          stats[:reassigned] += 1
          ae.update!(artist_id: keeper.id)
          keeper_event_ids.add(ae.event_id)
        end
      end

      merge_pronouns = merge.pronouns.to_s.strip
      if keeper.pronouns.to_s.strip.blank? && merge_pronouns.present?
        keeper.pronouns = merge.pronouns
      end

      kf = keeper.ra_followers
      mf = merge.ra_followers
      keeper.ra_followers = mf if mf.present? && (kf.blank? || mf > kf.to_i)

      keeper.genre_id ||= merge.genre_id if merge.genre_id.present?

      keeper.save! if keeper.changed?

      Artist.reassign_or_record_aliases_when_merging!(keeper, merge)
      merge.destroy!
    end

    stats
  end

  # When folding `merge` into `keeper`, keep any import aliases that pointed at `merge`
  # and record `merge.name` so that spelling still resolves to `keeper`.
  def self.reassign_or_record_aliases_when_merging!(keeper, merge)
    merge.artist_aliases.find_each do |al|
      keeper_primary_key = normalize_import_name_key(keeper.name)
      if al.normalized_key == keeper_primary_key
        al.destroy!
        next
      end

      other = ArtistAlias.where(normalized_key: al.normalized_key).where.not(id: al.id).first
      if other.nil?
        al.update!(artist_id: keeper.id)
      elsif other.artist_id == keeper.id
        al.destroy!
      else
        Rails.logger.warn(
          "ArtistAlias merge: dropping #{al.label.inspect} (normalized key already used by artist_id=#{other.artist_id})"
        )
        al.destroy!
      end
    end

    ArtistAlias.record_for_artist!(keeper, merge.name)
  end

  # Case-insensitive find or create; also folds accents (Obskür / Obskur, Esmé / Esme)
  def self.find_or_create_by_canonical_name!(name)
    return nil if name.blank?

    stripped = name.to_s.strip
    key = normalize_import_name_key(stripped)
    if key.present?
      hit = ArtistAlias.find_by(normalized_key: key)
      return hit.artist if hit
    end

    found = where("LOWER(TRIM(name)) = ?", stripped.downcase).first
    return found if found

    folded = key
    find_each do |artist|
      next if artist.name.blank?

      af = normalize_import_name_key(artist.name)
      return artist if af == folded
    end

    create!(name: stripped)
  end
end
