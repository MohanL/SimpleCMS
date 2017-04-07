require 'sinatra'
require 'mongoid'
require 'slim'
require 'redcarpet'

configure do
  Mongoid.load!("./mongoid.yml")
end

class Page
  include Mongoid::Document

  field :title,   :type => String
  field :content, :type => String
end

class Users
  include Mongoid::Document
  field :username,   :type => String
  field :email,   :type => String
  field :encrypted_password,   :type => String
  field :salt,   :type => String
  field :time_stamp,   :type => Date
end

 get '/pages' do
   @pages = Page.all
   @title = "Simple CMS: Page List"
   slim :index
 end

 get '/pages/new' do
   @page = Page.new
   slim :new
 end

 get '/pages/:id' do
   @page = Page.find(params[:id])
   @title = @page.title
   slim :show
 end

 post '/pages' do
    page = Page.create(params[:page])
    redirect to("/pages/#{page.id}")
 end
