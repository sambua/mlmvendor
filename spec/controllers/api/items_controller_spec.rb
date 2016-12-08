require 'rails_helper'

RSpec.describe Api::ItemsController, type: :request do

  let(:active_items) { create_list(:active_items_list, 5)}
  let!(:active_item) { create(:active_item) }
  let!(:inactive_item) { create(:inactive_item) }

  let(:json) { JSON.parse(response.body) } # symbolize_names: true in case if want to get data with data["key"]

  describe "GET #index" do
    before do
      active_items
      get "/api/items", as: :json # or get api_items_url
      #get :index, format: :json # in case if we will use type: :controller
    end

    it "active items visible" do
      # test for the 200 status-code
      expect(response).to be_success

      # Only active item is visible in home page
      expect(json["data"].to_s).to include('Active Product')

      # Draft item is not visile
      expect(json["data"].to_s).not_to include('Not Active Product Title')

      # There are only 1 active
      expect(json["data"].length).to eq(active_items.length + 1)
    end

  end

  describe "GET #show" do

    context "item is visile" do

      before(:each) do
        get api_item_url(id: active_item.id)
      end

      it "returns informaiton about item on a hash" do
        # Status has to be 200
        expect(response).to have_http_status(:success)

        # Item has to be shown
        expect(json["data"]["attributes"]["title"]).to eql active_item.title
      end

    end # /context item is visile

    context "item is NOT visile" do

      before(:each) do
        get api_item_url(id: inactive_item.id)
      end

      it "returns empty informaiton with error message" do
        # Inactive item is not visible
        expect(json["error"]).to include('Item not found')
      end

      it "has to return not found page" do
        expect(response).to have_http_status(404)
      end

    end # /context item is NOT visile

  end

  describe "POST #create" do
    context "when it was successfully created" do
      let(:valid_input) do
        # post :create, item: FactoryGirl.attributes_for(:item)
        @item_attributes = FactoryGirl.attributes_for :item
        post "/api/items", params: { item: @item_attributes }
      end

      before(:each) do
        valid_input
      end

      it "return with 201 response" do
        expect(response).to have_http_status(201)
      end

      it "get success message if item will be added successfully" do
        jdata = JSON.parse(response.body, symbolize_names: true)
        expect(json["success"]).to include("Item was successfully created.")
      end

      it "add new item to DB" do
        jdata = JSON.parse(response.body, symbolize_names: true)
        expect {
          @item_attributes = FactoryGirl.attributes_for :item
          post '/api/items', params: { item: @item_attributes }
        }.to change(Item, :count).by(1)
      end

    end

    context "When it's not creating new data" do
      let!(:invalid_input) do
        @invalid_item_attributes = { title: '', price: '' }
        post "/api/items", params: { item: @invalid_item_attributes }
        # process :create, method: :post, params: { item: @invalid_item_attributes }
      end

      it "render error json data" do
        # title can't be blanck
        expect(json["title"]).to include("can't be blank")

        # price can't be blanck
        expect(json["price"]).to include("can't be blank")
      end

      it "DB has to be stay on the same count" do
        expect {
          invalid_input
        }.not_to change(Item, :count)
      end

      it "return with 422 status" do
        expect(response).to have_http_status(422)
      end

    end

  end

  describe "PUT/PATCH #update" do

    context "when successfully updating" do
      let(:update_valid_data) do
        @update_attributes = { title: 'Updated Title', price: 1000 }
        FactoryGirl.attributes_for(:active_item, @update_attributes)
      end

      before(:each) do
        #process :update, method: :put, params: { id: active_item.id, item: update_valid_data } , format: :json
        put "/api/items/#{active_item.id}", params: { item: update_valid_data }
        active_item.reload
      end

      it "should get new title and price" do
        expect(active_item.title).to eq('Updated Title')
      end

      it "DB has to be stay at the same count" do
        expect {
          update_valid_data
        }.not_to change(Item, :count)
      end

    end

    context "unsuccessfully updating data" do
      let(:update_invalid_data) do
        @update_attributes = { title: '', price: 10 }
        FactoryGirl.attributes_for(:active_item, @update_attributes)
      end

      before{ put "/api/items/#{active_item.id}", as: :json, params: { item: update_invalid_data } }

      it "doesn't update item record in DB" do
        active_item.reload
        expect(active_item.price).not_to eq(10)
      end

      it "DB has to be stay at the same count" do
        expect {
          active_item.reload
        }.not_to change(Item, :count)
      end
    end

  end

  describe "DELETE #destroy" do

    def do_request(options = {})
      delete "/api/items/#{active_item.id}", as: :json, params: options
    end

    it 'returns 204 status code' do
      do_request
      expect(response.status).to eq(204)
    end

    it 'destroy post' do
      expect { do_request }.to change(Item, :count).by(-1)
    end

  end
end
