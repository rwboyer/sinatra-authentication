%w( rubygems sinatra lib/sinatra-authentication ).each { |f| require f }

use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

set :rpxapikey, '45ba29026c158111481c53d20dd27fead98130f1'
set :rpxappname, 'compassfail'
set :rpxserver, 'localhost:4567'

get "/" do
	render_login_logout
end

get "/test" do
	login_required
	"Made it"
end
