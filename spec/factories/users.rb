FactoryGirl.define do
  factory :user do
    username "username"
    email "user@example.com"
    password_hash "my_hashed_password"
  end
end
