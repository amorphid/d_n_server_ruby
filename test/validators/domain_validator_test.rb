require 'test_helper'

class DomainValidatorTest < ActiveSupport::TestCase
  def subject()
    DomainValidator
  end

  test "valid names" do
    max_byte_count = (1..255).map { "0" }.join(".")
    assert subject.new.validate_name(max_byte_count).class == IsOK::IsOK

    max_octet_count = (1..4).map { "0" * 63 }.join(".") + ".000"
    assert subject.new.validate_name(max_octet_count).class == IsOK::IsOK
  end

  test "domain_name is nil" do
    assert subject.new.validate_name(nil).class == IsOK::IsError
    assert subject.new.validate_name(nil).data == subject::NIL_ERROR
  end

  test "domain_name has too many bytes" do
    too_long = "0" * 510
    assert subject.new.validate_name(too_long).class == IsOK::IsError
    assert subject.new.validate_name(too_long).data == subject::MAX_BYTE_ERROR
  end

  test "a label is too long" do
    long_label = "0" * 64
    assert subject.new.validate_name(long_label).class == IsOK::IsError
    assert subject.new.validate_name(long_label).data == subject::LABEL_LENGTH_ERROR

    has_long_label = "0.0.0.#{long_label}"
    assert subject.new.validate_name(has_long_label).class == IsOK::IsError
    assert subject.new.validate_name(has_long_label).data == subject::LABEL_LENGTH_ERROR
  end

  test "too many octets" do
    too_many_1 = (1..16).map { "0" * 16 }.join(".")
    assert subject.new.validate_name(too_many_1).class == IsOK::IsError
    assert subject.new.validate_name(too_many_1).data == subject::OCTETS_LENGTH_ERROR
  end
end
