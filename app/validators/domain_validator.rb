class DomainValidator
  DELIMITER = ".".ord # 46
  IT_IS_TOTES_VALID = "it's legit yo".freeze
  MAX_BYTE_ERROR = "length exceeds max number of bytes".freeze
  MAX_BYTE_LENGTH = 509
  MAX_LABEL_LENGTH = 63
  MAX_OCTET_LENGTH = 255
  NIL_ERROR = "may not be nil".freeze

  LABEL_LENGTH_ERROR = "may not contain labels longer than #{MAX_LABEL_LENGTH} octets".freeze
  MAX_BYTE_LENGTH_PLUS_ONE = MAX_BYTE_LENGTH + 1
  OCTETS_LENGTH_ERROR = "length may not exceed #{MAX_OCTET_LENGTH} octets".freeze

  def validate_name(name)
    # may not be blank
    return IsOK.error(NIL_ERROR) if name.nil?

    # may be an empty string
    return IsOK.ok(name) if name.empty?

    # byte count may not exceed 509
    # defensive coding against overly long strings
    if name.each_byte.take(MAX_BYTE_LENGTH_PLUS_ONE).length > MAX_BYTE_LENGTH
      return IsOK.error(MAX_BYTE_ERROR)
    end

    label_octets = name.split(".").map { |label_str| label_str.each_byte.to_a }

    # label octet count may not exceed 63
    if label_octets.any? { |octets| octets.length > MAX_LABEL_LENGTH }
      return IsOK.error(LABEL_LENGTH_ERROR)
    end

    # total octects count may not exceed 255
    if label_octets.map { |octets| octets.length }.sum > MAX_OCTET_LENGTH
      return IsOK.error(OCTETS_LENGTH_ERROR)
    end

    IsOK.ok(IT_IS_TOTES_VALID)
  end
end
