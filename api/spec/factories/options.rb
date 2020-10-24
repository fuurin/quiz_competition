FactoryBot.define do
  factory :option do
    quiz { nil }
    text { "MyString" }
    is_correct_answer { false }
  end
end
