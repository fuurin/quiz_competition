FactoryBot.define do
  factory :quiz_set do
    sequence(:admin) { |n| Admin.create(email: "test##{n}@glossom.co.jp", password: "password#{n}") }
    sequence(:title) { |n| "QuizSet#{n}"}
  end
end
