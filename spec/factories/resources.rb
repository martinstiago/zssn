FactoryGirl.define do
  factory :resource do
    type nil
    survivor nil

    factory :water do
      type 'Water'
    end

    factory :food do
      type 'Food'
    end

    factory :medication do
      type 'Medication'
    end

    factory :ammunition do
      type 'Ammunition'
    end
  end
end
