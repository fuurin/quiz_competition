class QuizSet < ApplicationRecord
  belongs_to :admin
  has_many :quizzes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 128 }

  default_scope { order(id: :desc).select(:id, :name) }
  scope :by_admin, ->(admin) { where(admin: admin) }
end
