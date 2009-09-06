%w( rubygems sinatra lib/sinatra-authentication ).each { |f| require f }

#The low-down the comments are longer than the code
#Include sinatra-authentication

#We do need session cookies so let's do it the easy way

use Rack::Session::Cookie, :secret => 'SUPER SECRET STUFF'

#These are the only options and they all need to be set
#The rpxnow.com are self-explainitory just read the quickstart at rpxnow
set :rpxapikey, '45ba29026c158111481c53d20dd27fead98130f1'
set :rpxappname, 'compassfail'
set :rpxserver, 'localhost:4567'

#This is the really simple access control mechanism, just a hash with the 
#OpenID displayName and the associated role, you can make up the roles 
#yourself as you will see via the helper function useage
set :rpxadmins, { 'rwboyer.aperture' => 'admin' }

get "/" do
	#helper function - really should be used in your view templates
	#the only thing it outputs is the proper link tag and javascript
	render_login_logout
end

get "/test" do
	#This tests for any login and takes an optional failure page
	login_required('failure')
	"Made it"
end

get "/admin" do
	#This tests for logged in and that the user displayName has the given
	#priviledge and the optional failure page
	priv_required('admin', 'failure')
	"Made it"
end

get "/failure" do
	"Abyssmal Failure"
end
