# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = Admin.create!(
  email: Rails.application.credentials.admin[:email],
  password: Rails.application.credentials.admin[:password]
)

ActiveRecord::Base.transaction do
  3.times do |i|
    QuizSet.create!(admin: admin, title: "QuizSet#{i}")
  end
end

ActiveRecord::Base.transaction do
  quiz_set = QuizSet.last
  3.times do |i|
    quiz = Quiz.create!(quiz_set: quiz_set, number: quiz_set.quizzes.size + 1, text: "Question#{i}")
    3.times do |j|
      Option.create!(quiz: quiz, text: "Option#{j}", number: quiz.options.size + 1, is_correct_answer: i == j)
      quiz.reload
    end
    quiz_set.reload
  end
end
