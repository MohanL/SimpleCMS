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

 get '/pages' do
   @pages = Page.all
   @title = "Simple CMS: Page List"
   slim :index
 end

 get '/pages/:id' do
   @page = Page.find(params[:id])
   @title = @page.title
   slim :show
 end

 get '/pages/new' do
   @page = Page.new
   slim :new
 end

 post '/pages' do
    page = Page.create(params[:page])
    redirect to("/pages/#{page.id}")
 end
