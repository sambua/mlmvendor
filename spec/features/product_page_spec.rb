require 'rails_helper'

feature 'product page' do
  xscenario 'product public page' do
    item = FactoryGirl.create(:item, title: 'My Test Product')
    visit("/product/#{item.id}")

    exprect.to have_content('My Test Product')
  end
end
