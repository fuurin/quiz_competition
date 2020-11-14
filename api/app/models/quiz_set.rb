class QuizSet < ApplicationRecord
  belongs_to :admin
  has_one :competition, dependent: :destroy
  has_many :quizzes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 128 }

  default_scope { order(id: :desc) }
  scope :by_admin, ->(admin) { where(admin: admin) }

  def quizzes_by_attributes
    options = Option.by_quiz(quizzes).each_with_object({}) do |option, options|
      options[option.quiz_id] ||= []
      options[option.quiz_id].push(option.attributes)
    end
    quizzes.map do |quiz|
      att = quiz.attributes
      att[:options] = options[quiz.id]
      att
    end
  end
end
