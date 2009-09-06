%w( sinatra/base compass json rest_client).each { |f| require f }

module SinatraAuthentication
  VERSION = "0.0.2"
end

module Sinatra
  module OpenIDAuthentication
    def self.registered(app)
      #INVESTIGATE
      #the possibility of sinatra having an array of view_paths to load from
      #PROBLEM
      #sinatra 9.1.1 doesn't have multiple view capability anywhere
      #so to get around I have to do it totally manually by
      #loading the view from this path into a string and rendering it
      set :lil_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/"

      #TODO write captain sinatra developer man and inform him that the documentation
      #conserning the writing of extensions is somewhat outdaded/incorrect.
      #you do not need to to do self.get/self.post when writing an extension
      #In fact, it doesn't work. You have to use the plain old sinatra DSL


      #convenience for ajax but maybe entirely stupid and unnecesary
      get '/logged_in' do
        if session[:user]
          "true"
        else
          "false"
        end
      end

      get '/login' do
        "You must login using OpenID"
      end

      post '/login' do
	  	session[:user] = authenticate(params[:token])
		redirect '/'
      end

      get '/logout' do
        session[:user] = nil
        @message = "in case it weren't obvious, you've logged out"
        redirect '/'
      end

    end
  end

  module Helpers
  	def authenticate(token)
		puts "Auth call..."
		response = JSON.parse(
			RestClient.post(
				'https://rpxnow.com/api/v2/auth_info', 
				:token => token, 
				#'apiKey' => '45ba29026c158111481c53d20dd27fead98130f1', 
				'apiKey' => options.rpxapikey, 
				:format => 'json', :extended => 'false'))
		puts response.class
		puts response.inspect
		return response if response['stat'] = 'ok'
		return nil
	end

    def login_required
      if session[:user]
	  	puts session[:user].inspect
        return true
      else
        session[:return_to] = request.fullpath
        redirect '/login'
        return false
      end
    end

	def admin_required
		if s = session[:user]
			puts options.rpxadmins.inspect
			puts s.class
			puts s.inspect
			puts s['profile']['displayName']
			if options.rpxadmins[s['profile']['displayName']]
				return true
			end 
		end
		redirect '/'
		return false
	end

    def current_user
      session[:user]
    end

    def logged_in?
      !!session[:user]
    end

    def use_layout?
      !request.xhr?
    end

    def render_login_logout()
		if logged_in?
			"<a href='/logout'> Logout </a>"
		else
			"<a class = 'rpxnow' onclick='return false;' href='https://#{options.rpxappname}.rpxnow.com/openid/v2/signin?token_url=http://#{options.rpxserver}/login'> Login </a>" + render_js
		end
    end

	def render_js()
		"<script src='https://rpxnow.com/openid/v2/widget' type='text/javascript'>" +
		"<script type='text/javascript'> RPXNOW.overlay = true; RPXNOW.language_preference ='en'; </script>"
	end

  end

  register OpenIDAuthentication

end

