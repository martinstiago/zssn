class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude, :infected, :resources

  def infected
    object.infected?
  end

  def resources
    counts = Hash.new(0)
    object.resources.pluck(:type).each { |name| counts[name] += 1 }
    counts
  end
end
