class Quiz < ApplicationRecord
  belongs_to :quiz_set
  has_one :competition
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :text, presence: true, length: { maximum: 256 }

  default_scope { order(:number) }
  scope :by_quiz_set, ->(quiz_set) { where(quiz_set: quiz_set) }

  def next_quiz
    quiz_set.quizzes.where("number > #{number}").first
  end
end
