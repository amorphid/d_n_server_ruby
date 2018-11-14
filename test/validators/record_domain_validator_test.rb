require 'test_helper'

class RecordTypeValidatorTest < ActiveSupport::TestCase
  def subject()
    RecordTypeValidator
  end

  test "valid types" do
    a_record = Record.new(
      record_type: 1,
      rdata: "196.168.0.1"
    )
    a_response = subject.new.validate(a_record)
    assert a_response.class == IsOK::IsOK
    assert a_response.data == subject::YOU_ARE_MY_TYPE

    cname_record = Record.new(
      name: "subdomain",
      record_type: 5,
      rdata: "another.domain.com",
      zone: Zone.create(domain_name: "totes.valid.domain")
    )
    cname_response = subject.new.validate(cname_record)
    assert cname_response.class == IsOK::IsOK
    assert cname_response.data == subject::YOU_ARE_MY_TYPE
  end

  test "invalid A record" do
    record = Record.new(
      record_type: 1,
      rdata: "123.456.789.0123.456"
    )
    response = subject.new.validate(record)
    assert response.class == IsOK::IsError
    assert response.data == subject::A_ERROR
  end

  test "invalid CNAME record" do
    too_long = (1..256).map { "0" }.join(".")
    record = Record.new(
      name: "subdomain",
      record_type: 5,
      rdata: too_long,
      zone: Zone.create(domain_name: "totes.valid.domain")
    )
    response = subject.new.validate(record)
    assert response.class == IsOK::IsError
    assert response.data == subject::CNAME_ERROR
  end
end
