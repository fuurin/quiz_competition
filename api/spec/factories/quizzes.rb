FactoryBot.define do
  factory :quiz do
    quiz_set { create(:quiz_set) }
    number { quiz_set.reload; quiz_set.quizzes.size + 1 }
    sequence(:text) { |n| "Question#{n}"}
    image { '' }
    answer_image { '' }
  end
end
