FactoryBot.define do
  factory :article do
    title { "New Article" }
    content { "article content" }
    user
  end
end
