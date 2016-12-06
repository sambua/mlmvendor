require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  before(:each) do
    @items = FactoryGirl.create_list(:item, 5)
  end

  let(:active_item) { FactoryGirl.create(:active_item) }
  let(:inactive_item) { FactoryGirl.create(:inactive_item) }

  let(:json) { JSON.parse(response.body, symbolize_names: true) }

  describe "GET #index" do
    before do
      active_item
      inactive_item
    end

    before do
      get :index, format: :json
    end

    it "active items visible" do
      expect(json[:data][0][:attributes][:title]).to include('Active Product')
    end

    it "inactive items is hidden" do
      expect(json[:data][0][:attributes][:title]).not_to include('Not Active Product Title')
    end

    it "only one item is visible" do
      expect(json[:data].length).to eq(1)
    end

  end

  describe "GET #show" do
    before(:each) do
      # get :show, id: active_item.id, format: :json
      get :show, params: { id: active_item.id }
    end

    it "returns informaiton abput item on a hash" do
      expect(json[:data][:attributes][:title]).to eql active_item.title
    end

    # with shoulda code
    # it { should respond_with 200 }

    it "returns http success and list of items" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "when it was successfully created" do
      let(:valid_input) do
        # post :create, item: FactoryGirl.attributes_for(:item)
        @item_attributes = FactoryGirl.attributes_for :item
        post :create, params: { item: @item_attributes }
      end

      before(:each) do
        valid_input
      end

      it "return with 201 response" do
        expect(response).to have_http_status(201)
      end

      it "last item in DB should be last insert" do
        jdata = JSON.parse(response.body, symbolize_names: true)
        expect(json[:success]).to include("Item was successfully created.")
      end

      it "add new item to DB" do
        jdata = JSON.parse(response.body, symbolize_names: true)
        expect {
          @item_attributes = FactoryGirl.attributes_for :item
          post :create, params: { item: @item_attributes }
        }.to change(Item, :count).by(1)
      end

    end

    context "When it's not creating new data" do
      let(:invalid_input) do
        @invalid_item_attributes = { title: '', price: '' }
        process :create, method: :post, params: { item: @invalid_item_attributes }
      end

      before(:each) do
        invalid_input
      end


      it "render error json data" do
        jdata = JSON.parse(response.body, symbolize_names: true)
        expect(jdata).to have_content("can't be blank")
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
        FactoryGirl.attributes_for(:item, @update_attributes)
      end

      before(:each) do
        #process :update, method: :put, params: { id: active_item.id, item: update_valid_data } , format: :json
        put :update, id: active_item, item: update_valid_data
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

      it "DB has to be stay at the same count" do
        expect {
          update_valid_data
        }.not_to change(Item, :count)
      end

    end

    context "unsuccessfully updating data" do
      let(:update_invalid_data) do
        @update_attributes = { title: '', price: 10 }
        FactoryGirl.attributes_for(:item, @update_attributes)
      end

      it "doesn't update item record in DB" do
        put :update, id: active_item, item: update_invalid_data
        active_item.reload
        expect(active_item.price).not_to eq(10)
      end

      it "DB has to be stay at the same count" do
        expect {
          update_invalid_data
        }.not_to change(Item, :count)
      end
    end

  end

end
