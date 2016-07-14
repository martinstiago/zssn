class Survivor < ApplicationRecord
  has_many :resources
  accepts_nested_attributes_for :resources

  validates_presence_of :name, :age, :gender, :latitude, :longitude
  validates :gender, format: { with: /\A[M|F]\z/,
                               message: 'invalid gender' }

  def infected?
    infection_count >= 3
  end
end
