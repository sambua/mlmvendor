require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do

    it 'requires username' do
      user = User.new(username: '', email: 'test@example.com', password_hash: '1234')
      user.valid?
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'requires email' do
      user = User.new(username: 'test', email: '', password_hash: '1234')
      user.valid?
      expect(user.errors[:email]).not_to be_empty
    end

    it 'requires password' do
      user = User.new(username: 'test', email: 'test@example.com', password_hash: '')
      expect(user.valid?).to be_falsy
    end

  end
end
