class Quiz < ApplicationRecord
  belongs_to :quiz_set
  has_many :options, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :text, presence: true, length: { maximum: 256 }

  default_scope { order(:number) }
  scope :by_set, ->(quiz_set) { where(quiz_set: quiz_set) }

  def attributes_with_options
    hash = attributes
    hash[:options] = options.map { |o| o.attributes }
    hash
  end
end
