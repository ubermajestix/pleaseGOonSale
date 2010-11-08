class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :build_bookmarklet, :only=>[:my_rack]
  
  def my_rack
    @items = current_user.items.reverse
  end
  
end
