FactoryBot.define do
  factory :option do
    quiz { create(:quiz) }
    number { quiz.reload; quiz.options.size + 1 }
    sequence(:text) { |n| "Option#{n}"}
    is_correct_answer { false }
  end
end
