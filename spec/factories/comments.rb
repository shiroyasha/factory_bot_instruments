FactoryBot.define do
  factory :comment do
    content { "First!" }

    user
    article
  end
end
