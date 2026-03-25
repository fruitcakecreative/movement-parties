# frozen_string_literal: true

# Shared logic for merging duplicate Event rows (used by merge_duplicate_events rake and manual merge_two_events).
module MergeEventPair
  module_function

  # Prefer event name over listing format ("DANZI & FRNDZ — … at … • Mar 27")
  def best_merge_title(t1, t2)
    a = t1.to_s.strip
    b = t2.to_s.strip
    return b if a.blank?
    return a if b.blank?

    listing_format = /\s*[—\-]\s*|\s+at\s+|\s*•\s*/
    a_listing = a.match?(listing_format)
    b_listing = b.match?(listing_format)
    return a if a_listing && !b_listing
    return b if b_listing && !a_listing

    a.length >= b.length ? a : b
  end

  # Merges +dup+ into +keeper+, then destroys +dup+. Same rules as db:merge_duplicate_events.
  def merge_duplicate_into_keeper!(keeper, dup)
    raise ArgumentError, "same event" if keeper.id == dup.id

    ActiveRecord::Base.transaction do
      merge_attrs = {}
      Event::SOURCE_URL_COLUMNS.each do |col|
        next if col == "event_url" && keeper.event_url.present?

        val = dup.send(col)
        next if val.blank?

        merge_attrs[col] = val if keeper.send(col).blank?
      end
      keeper.update_columns(merge_attrs) if merge_attrs.any?

      unless keeper.manual_override_title
        best_title = best_merge_title(keeper.title, dup.title)
        keeper.update_column(:title, best_title) if best_title.present?
      end

      unless keeper.manual_override_genres
        dup.genres.each { |g| keeper.genres << g unless keeper.genres.include?(g) }
      end

      unless keeper.manual_override_artists
        dup.artists.each { |a| keeper.artists << a unless keeper.artists.include?(a) }
      end

      keeper_user_ids = keeper.event_attendees.pluck(:user_id).to_set
      dup.event_attendees.each do |ea|
        if keeper_user_ids.include?(ea.user_id)
          ea.destroy
        else
          ea.update!(event_id: keeper.id)
          keeper_user_ids.add(ea.user_id)
        end
      end
      dup.ticket_posts.update_all(event_id: keeper.id)

      keeper_ue_user_ids = keeper.user_events.pluck(:user_id).to_set
      dup.user_events.each do |ue|
        if keeper_ue_user_ids.include?(ue.user_id)
          ue.destroy
        else
          ue.update!(event_id: keeper.id)
          keeper_ue_user_ids.add(ue.user_id)
        end
      end

      unless keeper.manual_override_times
        keeper.update_column(:start_time, dup.start_time) if keeper.start_time.blank? && dup.start_time.present?
        keeper.update_column(:end_time, dup.end_time) if keeper.end_time.blank? && dup.end_time.present?
      end
      unless keeper.manual_override_ticket
        %i[ticket_price ticket_tier ticket_wave].each do |attr|
          next unless keeper.respond_to?(attr)

          keeper.update_column(attr, dup.send(attr)) if keeper.send(attr).blank? && dup.send(attr).present?
        end
      end
      %i[description event_image_url promoter age].each do |attr|
        next unless keeper.respond_to?(attr)

        keeper.update_column(attr, dup.send(attr)) if keeper.send(attr).blank? && dup.send(attr).present?
      end

      dup.destroy!
    end
  end

  def clear_event_caches
    %w[movement mmw].each { |ck| Rails.cache.delete("events-v1:#{ck}") rescue nil }
    %w[movement mmw].each { |ck| Rails.cache.delete("events-v2:#{ck}") rescue nil }
    %w[movement mmw].each { |ck| Rails.cache.delete("events-v4:#{ck}") rescue nil }
  end
end
