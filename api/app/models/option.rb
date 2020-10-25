class Option < ApplicationRecord
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :text, presence: true, length: { maximum: 128 }

  default_scope { order(:number) }
  scope :by_quiz, ->(quiz) { where(quiz: quiz) }
  scope :correct, ->() { where(is_correct_answer: true) }
end
