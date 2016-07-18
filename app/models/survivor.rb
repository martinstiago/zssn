class Survivor < ApplicationRecord
  INFECTION_THRESHOLD = 3

  has_many :resources
  accepts_nested_attributes_for :resources

  validates_presence_of :name, :age, :gender, :latitude, :longitude
  validates :gender, format: { with: /\A[M|F]\z/,
                               message: 'invalid gender' }

  scope :infected, -> { where('infection_count >= ?', INFECTION_THRESHOLD) }
  scope :not_infected, -> { where('infection_count < ?', INFECTION_THRESHOLD) }

  def infected?
    infection_count >= INFECTION_THRESHOLD
  end
end
