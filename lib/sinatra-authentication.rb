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
        if session[:user]
          "true"
        else
          "false"
        end
      end

      get '/login' do
        haml get_view_as_string("login.haml"), :layout => use_layout?
      end

      post '/login' do
	  	session[:user] = authenticate(params[:token)
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
		response = JSON.parse(
			RestClient.post(
				'https:://rpxnow.com/api/v2/auth_info', 
				:token => token, 
				'apiKey' => '', 
				:format => 'json', :extended => 'false'))
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

    def render_login_logout(html_attributes = {:class => ""})
    css_classes = html_attributes.delete(:class)
    parameters = ''
    html_attributes.each_pair do |attribute, value|
      parameters += "#{attribute}=\"#{value}\" "
    end

      result = "<div id='sinatra-authentication-login-logout' >"
      if logged_in?
        logout_parameters = html_attributes
        # a tad janky?
        logout_parameters.delete(:rel)
        result += "<a href='/users/#{current_user.id}/edit' class='#{css_classes} sinatra-authentication-edit' #{parameters}>edit account</a> "
        result += "<a href='/logout' class='#{css_classes} sinatra-authentication-logout' #{logout_parameters}>logout</a>"
      else
        result += "<a href='/signup' class='#{css_classes} sinatra-authentication-signup' #{parameters}>signup</a> "
        result += "<a href='/login' class='#{css_classes} sinatra-authentication-login' #{parameters}>login</a>"
      end

      result += "</div>"
    end
  end

  register LilAuthentication
end

end
