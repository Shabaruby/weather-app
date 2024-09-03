# frozen_string_literal: true

# Temperature
class Temperature < ApplicationRecord
  validates :recorded_at, uniqueness: true
end
