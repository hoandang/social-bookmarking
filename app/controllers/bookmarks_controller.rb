class BookmarksController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]  

  def index
  end

  # new bookmark form
  def new 
    @bookmark = current_user.bookmarks.new
  end

  # create bookmark
  def create
    @bookmark = current_user.bookmarks.build(params[:bookmark])
    if @bookmark.save
      params[:tags].split.each do |tag|
        associate @bookmark, tag
      end
      redirect_to current_user
    else
      render 'new'
    end
  end

  # update bookmark
  def update
    @bookmark = current_user.bookmarks.find(params[:id])
    if @bookmark.update_attributes(params[:bookmark])
      unless params[:hidden].eql? params[:tags]
        @bookmark.associations.destroy_all
        params[:tags].split.each do |tag|
          associate @bookmark, tag
        end
      end
      flash[:success] = 'Bookmark updated'
      redirect_to current_user
    else
      render 'edit'
    end
  end

  # create a edit bookmark form
  def edit
    @bookmark = current_user.bookmarks.find(params[:id])
  end

  # destroy bookmark
  def destroy
    #render text: params.inpsect
    current_user.bookmarks.find(params[:id]).destroy
    flash[:success] = 'A bookmark was destroyed'
    redirect_to current_user
  end

  # create added bookmark form
  def add 
    @bookmark = Bookmark.find(params[:bookmark_id])
  end

  # helpers
  private 
  def correct_user
    @user = Bookmark.find(params[:id]).user
    redirect_to signin_url, notice: 'Please sign in.' unless current_user?(@user)
  end    

  def duplicated_tag? tag
    Tag.where(name: tag).exists?
  end

  def associate bookmark, tag
    if duplicated_tag? tag
      tag = Tag.find_by_name(tag)
      Association.create(bookmark_id: bookmark.id, tag_id: tag.id) 
    else
      tag = Tag.create(name: tag)
      Association.create(bookmark_id: bookmark.id, tag_id: tag.id) 
    end
  end
end
