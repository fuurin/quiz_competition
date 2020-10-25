class Competition < ApplicationRecord
  has_one :quiz_set
  has_one :quiz

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_save :set_first_quiz
  before_save :set_rid

  private

  def set_first_quiz
    self.quiz = quiz_set.quizzes.first
  end

  def set_rid
    loop do
      self.rid = SecureRandom.base64(Settings.models.competition.rid_length)
      return unless find_by(rid: rid)
    end
  end
end
