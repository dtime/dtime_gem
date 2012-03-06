Dtime.endpoint = "http://localhost:9292"
@client_id = '4ee43e9abce748bebf000002'
@client_secret = 'goodpassword'

def client_token
  Dtime.new(:client_id => @client_id, :client_secret => @client_secret).get_client_token
end

@root = Dtime.new(:oauth_token => client_token.token)
@anon = @d = Dtime.new()


