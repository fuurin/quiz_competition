class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  belongs_to :quiz
  belongs_to :option

  before_validation :set_competition

  private

  def set_competition
    self.competition = user.competition
  end
end
