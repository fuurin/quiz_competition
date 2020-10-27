class Competition < ApplicationRecord
  belongs_to :quiz_set
  belongs_to :quiz
  has_many :users, dependent: :destroy
  has_many :answers, dependent: :destroy

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_validation :set_first_quiz, :set_rid, on: :create

  def result
    quizzes = quiz_set.quizzes.where("number <#{'=' unless question?} #{quiz.number}")
    quiz_map = quizzes.each_with_object({}).with_index { |(q, m), i| m[q.id] = i }
    user_map = users.each_with_object({}).with_index { |(u, m), i| m[u.id] = i }
    result_plane = Array.new(user_map.size).map{ Array.new(quiz_map.size, 0) }
    answers.includes(:option).each do |answer|
      next unless answer.option.is_correct_answer
      result_plane[user_map[answer.user_id]][quiz_map[answer.quiz_id]] = 1
    end
    result = users.map do |user|
      {
        name: user.name,
        email: user.email,
        correct_num: result_plane[user_map[user.id]].sum,
      }.merge(
        result_plane[user_map[user.id]].each_with_object({}).with_index do |(r, m), i|
          m["q#{i+1}".to_sym] = r.zero? ? '×' : '○'
        end
      )
    end.sort { |a, b| a[:correct_num] <=> b[:correct_num] }
    result.each_with_index { |r, i| r[:rank] = i + 1}
  end

  private

  def set_first_quiz
    self.quiz = quiz_set.quizzes.first
  end

  def set_rid
    loop do
      self.rid = SecureRandom.alphanumeric(Settings.models.competition.rid_length)
      return unless Competition.find_by(rid: rid)
    end
  end
end
