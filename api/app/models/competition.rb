class Competition < ApplicationRecord
  belongs_to :quiz_set
  belongs_to :quiz
  has_many :users, dependent: :destroy
  has_many :answers, dependent: :destroy

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_validation :set_first_quiz, :set_rid, on: :create

  def result_and_users_map
    current_quiz_num = quiz.number
    users_map = {}
    result = quiz_set.quizzes.each_with_object([]) do |quiz, res|
      if (question? ? quiz.number >= current_quiz_num : quiz.number > current_quiz_num)
        break
      end
      correct_option_ids = quiz.options.correct.pluck(:id)
      res.push(Answer.by_quiz(quiz).each_with_object({}) do |answer, judges|
        user = answer.user
        judges[user.id] = correct_option_ids.include?(answer.option.id) ? 1 : 0
        users_map[user.id] ||= user.name
      end)
    end
    [result, users_map]
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
