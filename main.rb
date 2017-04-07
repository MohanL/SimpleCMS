require 'sinatra'
require 'mongoid'
require 'slim'
require 'redcarpet'
require 'pry'

configure do
  Mongoid.load!("./mongoid.yml")
  enable :sessions

  helpers do
    def admin?
      session[:admin]
    end
    def protected!
      puts admin?
      halt 401,"You are not authorized to see this page!" unless admin?
    end
  end
end

class Page
  include Mongoid::Document

  field :title,   :type => String
  field :content, :type => String
  field :permalink, type: String, default: -> { make_permalink } #so the link looks better

  def make_permalink
    title.downcase.gsub(/W/,'-').squeeze('-').chomp('-') if title
  end
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
    # binding.pry #if gets you into tracer, gem uninstall pry-nav
    protected!
   @pages = Page.all
   @title = "Simple CMS: Page List"
   slim :index
 end

 get '/pages/new' do
   protected!
   @page = Page.new
   slim :new
 end

 get '/pages/:id' do
   @page = Page.find(params[:id])
   @title = @page.title
   slim :show
 end

 post '/pages' do
   protected!
   page = Page.create(params[:page])
   redirect to("/pages/#{page.id}")
 end

 get '/pages/:id/edit' do
    protected!
    @page = Page.find(params[:id])
    slim :edit
 end

 put '/pages/:id' do
    protected!
    page = Page.find(params[:id])
    page.update_attributes(params[:page])
    redirect to("/pages/#{page.id}")
 end

 get '/pages/delete/:id' do
     protected!
    @page = Page.find(params[:id])
    slim :delete
 end

 delete '/pages/:id' do
     protected!
    Page.find(params[:id]).destroy
    redirect to('/pages')
 end

 get '/:permalink' do
    begin
      @page = Page.find_by(permalink: params[:permalink])
    rescue
      pass
    end
    slim :show
 end

 get '/login' do
   session[:admin]=true;
   redirect back
 endl

 get '/logout' do
   session[:admin]=false;
   redirect back
 end

 # TODO: (Mohan) fix the sass
 # get '/styles/main.css' do
 #     puts 'asking for styles'
 #     scss :styles
 # end
