require 'ipaddr'

class RecordTypeValidator < ActiveModel::Validator
  A_ERROR = "rdata not a valid IPv4 address".freeze
  CNAME_ERROR = "rdata not a valid domain"
  YOU_ARE_MY_TYPE = "looks good to me!".freeze
  TYPE_METHODS = {
    1 => :a,
    5 => :cname
  }.freeze

  def validate(record)
    type_method = TYPE_METHODS.fetch(record.record_type, :unknown)

    send(type_method, record)
  end

  def a(record)
    # max length of IPv4 address (e.g. xxx.xxx.xxx.xxx) is 15
    maybe_ip = record.rdata[0...15]
    # using rescue to interceot error on invalid maybe_ip
    IPAddr.new(maybe_ip).ipv4?
    IsOK.ok(YOU_ARE_MY_TYPE)
  rescue
    IsOK.error(A_ERROR)
  end

  def cname(record)
    # rdata for CNAME must be a valid domain name
    case DomainValidator.new.validate_name(record.rdata)
    when IsOK::IsOK
      IsOK.ok(YOU_ARE_MY_TYPE)
    else
      IsOK.error(CNAME_ERROR)
    end
  end

  def unknown(record)
    # assuming there's no validation to do for unknown types
    IsOK.ok(YOU_ARE_MY_TYPE)
  end
end
