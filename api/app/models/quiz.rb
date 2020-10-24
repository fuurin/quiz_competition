class Quiz < ApplicationRecord
  belongs_to :quiz_set
  has_many :options, dependent: :destroy

  validates :number, presence: true, numericality: true, only_integer: true, greater_than: 0
  validates :text, presence: true, length: { maximum: 256 }

  default_scope { order(:number).includes(:option) }
  scope :by_set, ->(quiz_set) { where(quiz_set: quiz_set) }
end
