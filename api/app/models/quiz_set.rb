class QuizSet < ApplicationRecord
  belongs_to :admin
  has_many :quizzes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 128 }

  default_scope { order(id: :desc) }
  scope :by_admin, ->(admin) { where(admin: admin) }

  def quizzes_by_attributes
    quizzes.map { |quiz| quiz.attributes_with_options }
  end
end
