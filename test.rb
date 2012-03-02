Dtime.endpoint = "http://localhost:9292"
@client_id = '4ee43e9abce748bebf000002'
@client_secret = 'goodpassword'

def client_token
  Dtime.get_client_token(:client_id => @client_id, :client_secret => @client_secret)
end

@root = Dtime.new(:oauth_token => client_token.token)
@anon = Dtime.new()
