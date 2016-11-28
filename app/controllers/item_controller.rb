class ItemController < ApplicationController

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
  end

  def index
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:status, :title, :price, :slug, :description, :excerpt)
  end

end
