require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]

  def index 
    @user = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    if current_user? @user
      @bookmarks = @user.bookmarks.paginate(page: params[:page], per_page: 10)
    else
      @bookmarks = @user.bookmarks.paginate(page: params[:page], per_page: 10).find_all_by_privacy(false)
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to Pinboard!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def feed
    @feed_items = current_user.feed.paginate(page: params[:page]).find_all_by_privacy(false)
  end

  # search bookmark by tag name
  def search
    @user = User.find(params[:user_id])
    result_search = search_bookmarks_by params[:tag_name], @user

    if current_user? @user
      @bookmarks = result_search.paginate(page: params[:page], per_page: 10) 
    else
      temp = []
      result_search.each do |bookmark|
        unless bookmark.privacy? then
          temp.push(bookmark)
        end
      end
      @bookmarks = temp.paginate(page: params[:page], per_page: 10)
    end
  end

  private
    def signed_in_user
      redirect_to signin_url, notice: 'Please sign in.' unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def search_bookmarks_by tag_name, user
      @bookmarks = []
      begin
        tag_id = Tag.find_by_name(tag_name).id
        user.bookmarks.each do |b|
          b.associations.each do |a|
            if a.tag_id == tag_id
              @bookmarks.push(b)
            end
          end
        end
        @bookmarks
      rescue
        @bookmark
      end
    end
end
