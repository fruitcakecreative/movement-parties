require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) do
    User.create!(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      picture: 'https://example.com/pic.jpg'
    )
  end

  def auth_headers
    { 'Authorization' => "Bearer #{user.authentication_token}" }
  end

  describe 'PATCH /api/user' do
    it 'persists profile_extra to users.profile_info' do
      patch '/api/user',
            params: {
              user: {
                profile_extra: {
                  weekends_attended: '4',
                  hometown: 'Ann Arbor, MI',
                  artist_excited: 'Carl Cox',
                  favorite_venue: 'TV Lounge',
                  movement_pro_tip: 'Wear comfy shoes.'
                }
              }
            },
            headers: auth_headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['profile_extra']).to include(
        'weekends_attended' => '4',
        'hometown' => 'Ann Arbor, MI',
        'artist_excited' => 'Carl Cox',
        'favorite_venue' => 'TV Lounge',
        'movement_pro_tip' => 'Wear comfy shoes.'
      )

      user.reload
      expect(user.profile_info).to be_present
      stored = JSON.parse(user.profile_info)
      expect(stored['hometown']).to eq('Ann Arbor, MI')
    end

    it 'merges profile_extra without wiping omitted keys' do
      user.assign_profile_extra!(hometown: 'Chicago')
      user.save!

      patch '/api/user',
            params: { user: { profile_extra: { artist_excited: 'Amelie Lens' } } },
            headers: auth_headers,
            as: :json

      expect(response).to have_http_status(:ok)
      user.reload
      extra = user.profile_extra_hash
      expect(extra['hometown']).to eq('Chicago')
      expect(extra['artist_excited']).to eq('Amelie Lens')
    end
  end

  describe 'GET /api/users/:id' do
    it 'returns profile_extra for a friend' do
      friend = User.create!(
        name: 'Friend',
        username: 'frienduser',
        email: 'friend@example.com',
        password: 'password123',
        picture: 'https://example.com/f.jpg'
      )
      friend.assign_profile_extra!(hometown: 'Detroit, MI')
      friend.save!
      Friendship.create!(user: user, friend: friend, status: 'accepted')

      get "/api/users/#{friend.id}", headers: auth_headers, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['profile_extra']).to eq('hometown' => 'Detroit, MI')
    end
  end
end
