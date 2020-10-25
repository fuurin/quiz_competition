class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  belongs_to :quiz
  belongs_to :option

  before_validation :set_competition

  scope :by_user, ->(user) { where(user: user) }
  scope :by_quiz, ->(quiz) { where(quiz: quiz) }

  private

  def set_competition
    self.competition = user.competition
  end
end
