FactoryGirl.define do
  factory :item do
    status 1
    slug "product-name"
    price 1.5
    title "Product Name"
    excerpt "Short description of product"
    description "Long description of product"
  end
end
