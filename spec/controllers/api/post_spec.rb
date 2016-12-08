require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  subject { JSON.parse(response.body) }

  describe 'GET #index' do
    let!(:posts) { create_list(:post, 3) }
    before { get api_posts_url }

    it 'returns 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'returns list of posts' do
      expect(subject.length).to eq(posts.length)
    end
  end

  describe 'POST #create' do
    let(:user_attributes) { { name: 'test-user' } }
    let(:post_params) { { post: attributes_for(:post).merge(user_attributes: user_attributes) } }

    it 'returns 201 status code' do
      do_request(post_params)
      expect(response.status).to eq(201)
    end

    it 'changes post count' do
      expect { do_request(post_params) }.to change(Post, :count).by(1)
    end

    it 'returns post' do
      do_request(post_params)
      expect(subject['title']).to eq(post_params[:post][:title])
    end

    def do_request(options = {})
      post '/api/posts', as: :json, params: options
    end
  end

  describe 'GET #show' do
    let!(:post) { create(:post) }
    before { get api_post_url(id: post.id) }

    it 'returns 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'returns post' do
      expect(subject['id'].to_i).to eq(post.id)
      expect(subject['title']).to eq(post.title)
    end
  end

  describe 'PUT #update' do
    let!(:post) { create(:post, title: 'Old title') }
    let(:title) { 'New title' }

    before { put "/api/posts/#{post.id}", as: :json, params: { post: { title: title } } }

    it 'returns 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'update post' do
      expect(subject['title']).to eq(title)
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post) }

    it 'returns 204 status code' do
      do_request
      expect(response.status).to eq(204)
    end

    it 'destroy post' do
      expect { do_request }.to change(Post, :count).by(-1)
    end

    def do_request(options = {})
      delete "/api/posts/#{post.id}", as: :json, params: options
    end
  end
end
