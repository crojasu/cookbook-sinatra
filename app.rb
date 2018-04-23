require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipes.rb"
require_relative "cookbook.rb"


configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

COOKBOOK = Cookbook.new('recipe.csv')

# get '/' do
#   erb :index
# end

get '/about' do
  erb :about
end

# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end

get '/' do
  @recipes = COOKBOOK.all
  erb :index
end

GET /new

set :bind, '0.0.0.0'


