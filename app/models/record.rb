class Record < ApplicationRecord
  RANGE_16_BITS = 0..(2**16 - 1)
  RANGE_32_BITS = 0..(2**32 - 1)

  belongs_to :zone

  validates :name,
    record_domain: true

  validates :record_type,
    inclusion: { in: RANGE_16_BITS },
    record_type: true

  validates :record_class,
    inclusion: { in: RANGE_16_BITS }

  validates :ttl,
    inclusion: { in: RANGE_32_BITS }

  validates :rdata,
    presence: true
end
