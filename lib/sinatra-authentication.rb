%w( sinatra/base compass json rest_client).each { |f| require f }

module SinatraAuthentication
  VERSION = "0.0.2"
end

module Sinatra
  module LilAuthentication
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
	  	puts "GET - logged_in"
	  	puts session[:user].class
		puts session[:user].inspect
        if session[:user]
          "true"
        else
          "false"
        end
      end

      get '/login' do
	  	puts "GET - /login"
	  	puts session[:user].class
		puts session[:user].inspect
        "You must login using OpenID"
      end

      post '/login' do
	  	session[:user] = authenticate(params[:token])
	  	puts "POST - /login"
	  	puts session[:user].class
		puts session[:user].inspect
		redirect '/'
      end

      get '/logout' do
        session[:user] = nil
        @message = "in case it weren't obvious, you've logged out"
	  	puts "GET - /logout"
	  	puts session[:user].class
		puts session[:user].inspect
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
        return true
      else
        session[:return_to] = request.fullpath
        redirect '/login'
        return false
      end
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

    #BECAUSE sinatra 9.1.1 can't load views from different paths properly
    def get_view_as_string(filename)
      view = options.lil_authentication_view_path + filename
      data = ""
      f = File.open(view, "r")
      f.each_line do |line|
        data += line
      end
      return data
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

  register LilAuthentication

end

