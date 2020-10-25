class Competition < ApplicationRecord
  belongs_to :quiz_set
  belongs_to :quiz

  enum status: { question: 0, answer: 1, result: 2 }

  validates :status, presence: true
  validates :rid, presence: true

  before_validation :set_first_quiz, :set_rid, on: :create

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
