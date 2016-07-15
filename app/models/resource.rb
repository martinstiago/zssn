class Resource < ApplicationRecord
  belongs_to :survivor, optional: true
end
