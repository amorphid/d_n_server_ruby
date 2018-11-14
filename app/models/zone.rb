class Zone < ApplicationRecord
  has_many :records

  validates :domain_name,
    zone_domain: true
end
