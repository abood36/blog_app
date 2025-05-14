FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    sequence(:body) { |n| "This is the body of post #{n}" }
    association :user
    after(:build) do |post|
      post.tags << create(:tag) if post.tags.empty?
    end
  end
end 