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
    FactoryBot.create(:quiz_set, admin: admin)
  end
end

ActiveRecord::Base.transaction do
  quiz_set = QuizSet.last
  3.times do |i|
    quiz = FactoryBot.create(:quiz, quiz_set: quiz_set)
    3.times do |j|
      FactoryBot.create(:option, quiz: quiz, is_correct_answer: i == j)
    end
  end
end
