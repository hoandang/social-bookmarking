module BookmarksHelper
  def duplicated_url? url
    current_user.bookmarks.any?{|b| b.url.eql? url }
  end 
end
