module Api::V1
  class ItemsController < ApiController

    # GET /v1/items
    def index
      render json: Item.all
    end

    def new
      @item = Item.new
    end

    def create
      @item = Item.new(item_params)
      if @item.save
        redirect_to v1_item_url( url ), notice: 'Successfully created'
      end
    end

    def show
      @item = Item.friendly.find(params[:id])
      render json: @item
    end

    def update
      @item = Item.friendly.find(params[:id])
    end

    private

    def item_params
      params.permit(:status, :title, :price, :description, :excerpt)
    end

  end
end
