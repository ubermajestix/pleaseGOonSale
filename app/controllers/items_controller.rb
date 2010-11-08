class ItemsController < ApplicationController
  
  def create
    @user = User.first(:conditions=>{:authentication_token => params["user_id"]})
    item = Item.add_item(params['item'], @user) 
    respond_to do |wants|
      if item.errors.on_base
        wants.json{ render :text => params["jsonp"] + "({error: '#{item.errors.on_base}'})"}
      else
        wants.json{ render :text => params["jsonp"] + "(#{item.to_json})"}
      end
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    item = Item.find(params[:id])
    @user.items.delete(item)
    respond_to do |wants|
      wants.html { redirect_to my_rack_path }
    end
  end
  
end
