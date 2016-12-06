class ItemsController < ApplicationController
    # only accept json requests

    # GET /items
    def index
      render json: Item.where(status: 1)
    end

    # GET /items/:id
    def show
      @item = Item.friendly.find(params[:id])
      render json: @item
    end

    # POST /items
    def create
      @item = Item.new(item_params)
      if @item.save
        render json: @item, status: 201, location: @item
      else
        render json: @item.errors, status: 422
      end
    end

    # GET /item/:id
    def edit
      @item = Item.friendly.find(params[:id])
      render json: @item
    end

    # PATCH /items/:id
    def update
      @item = Item.friendly.find(params[:id])

      if @item.update_attributes(item_params)
        redirect_to item_path(@item)
      else
        render json: @item.errors, status: 422
      end

      # render nothing:true

    end

    # DELETE /items/:id
    def destroy
      @item.destroy
      head 204
    end

    private

    def item_params
      params.require(:item).permit(:status, :title, :price, :description, :excerpt)
      # params.permit(:status, :title, :price, :description, :excerpt)
    end
end
