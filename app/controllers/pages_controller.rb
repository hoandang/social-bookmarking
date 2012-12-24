class PagesController < ApplicationController
  def home
    if signed_in? 
      redirect_to feed_user_path current_user
    end
  end
end
