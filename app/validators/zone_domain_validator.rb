class ZoneDomainValidator < ActiveModel::Validator
  def validate(zone)
    validator = DomainValidator.new()
    response = validator.validate_name(zone.domain_name)
    case response
    when IsOK::IsOK
      :noop
    when IsOK::IsError
      zone.errors.add(:domain_name, response.data)
    else
      raise "this should not happen"
    end
  end
end
