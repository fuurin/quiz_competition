class Option < ApplicationRecord
  belongs_to :quiz

  validates :number, presence: true, numericality: true, only_integer: true, greater_than: 0
  validates :text, presence: true, length: { maximum: 128 }

  default_scope { order(:number) }
  scope :by_quiz, ->(quiz) { where(quiz: quiz) }
end
