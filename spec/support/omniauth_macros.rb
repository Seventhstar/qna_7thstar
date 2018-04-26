module OmniauthMacros
  def mock_auth_hash(provider)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider' => provider.to_s,
      'uid' => '123545',
      'user_info' => {
        'name' => 'mkuser'
      },
      'credentials' => {
        'token' => 'mk_token',
        'secret' => 'mk_secret'
      }
    }.merge(provider == :github ? {info: {email: 'git@hub.ru'}} : {}))
  end


  def mock_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        {
            provider: 'twitter',
            uid: '12345',
            email: 'quwhduq@test.ru',
	    confirmed_at: Date.today,
            info: {}
        })
  end

end