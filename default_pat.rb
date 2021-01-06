puts "Creating api personal access token for root".color(:red)

# Default token:  9foA-QKCMgxSxf2iZZ2W
# Default scopes: ["api", "read_user", "read_api", "read_repository", "write_repository"]

token = PersonalAccessToken.new
token.user_id = User.find_by(username: 'root').id
token.name = 'api-token-for-testing'
token.scopes = []
token.set_token('')
token.save

puts 'TOKEN CREATION COMPLETE'.color(:green)