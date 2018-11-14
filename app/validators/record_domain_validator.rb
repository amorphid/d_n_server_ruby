class RecordDomainValidator < ActiveModel::Validator
  VALID_ROOT_DOMAIN = "This domain is where it's @"
  BLANK_ERROR = "may not be blank".freeze
  ZONE_BLANK_ERROR = "requires association with zone".freeze
  ZONE_BLANK_DOMAIN_NAME_ERROR = "requires association with zone that has non-blank domain name".freeze

  def validate(record)
    return set_error(record, BLANK_ERROR) if record.name.blank?
    # TODO: find better way to test than returning VALID_ROOT_DOMAIN
    return VALID_ROOT_DOMAIN if record.name == "@" # special case indicating root domain
    return set_error(record, ZONE_BLANK_ERROR) unless record.zone
    return set_error(record, ZONE_BLANK_DOMAIN_NAME_ERROR) if record.zone.domain_name.blank?

    validator = DomainValidator.new()
    record_domain = record.name + "." + record.zone.domain_name
    response = validator.validate_name(record_domain)
    case response
    when IsOK::IsOK
      :noop
    when IsOK::IsError
      set_error(record, response.data)
    else
      raise "this should not happen"
    end
  end

  def set_error(record, error)
    record.errors.add(:name, error)
  end
end
