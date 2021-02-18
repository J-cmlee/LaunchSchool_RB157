# frozen_string_literal: true

require 'yaml'
require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do
  @data = YAML.load_file('users.yaml')
  @users = @data.map { |k, _| k.to_s }
end

helpers do
  def get_interests(username)
    @data[username.to_sym][:interests]
  end

  def count_interests
    interests = []
    @users.each do |user|
      interests += get_interests(user)
    end
    interests.uniq.count
  end
end

get '/' do
  erb :user_index
end

get '/user/:name' do
  @name = params[:name]
  @email = @data[@name.to_sym][:email]

  erb :user
end
