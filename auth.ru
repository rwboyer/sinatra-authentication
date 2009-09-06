require 'rubygems'
require 'sinatra'

set :rpxapikey, '45ba29026c158111481c53d20dd27fead98130f1'
set :rpxappname, 'compassfail'
set :rpxserver, 'localhost:9292'

disable :run

require 'test.rb'

run Sinatra::Application
