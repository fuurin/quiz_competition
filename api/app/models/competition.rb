class Competition < ApplicationRecord
  belongs_to :quiz_set
  belongs_to :quiz

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_create :set_first_quiz, :set_rid

  private

  def set_first_quiz
    self.quiz = quiz_set.quizzes.first
  end

  def set_rid
    loop do
      self.rid = SecureRandom.urlsafe_base64(Settings.models.competition.rid_length)
      return unless find_by(rid: rid)
    end
  end
end
