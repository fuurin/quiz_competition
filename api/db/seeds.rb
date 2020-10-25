# herokuではspecディレクトリを扱わないようで、factory_botが使えないため普通に作る

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
    quiz = Quiz.create!(quiz_set: quiz_set, number: i + 1, text: "Question#{i + 1}")
    3.times do |j|
      Option.create!(quiz: quiz, text: "Option#{j + 1}", number: j + 1, is_correct_answer: i == j)
    end
  end
end
