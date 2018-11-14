require 'test_helper'

class RecordDomainValidatorTest < ActiveSupport::TestCase
  def subject()
    RecordDomainValidator
  end

  test "name is root domain" do
    record = Record.new(name: "@")
    assert subject.new.validate(record) == subject::VALID_ROOT_DOMAIN
  end

  test "name is blank" do
    record = Record.new()
    record.valid?
    name_errors = record.errors.messages.fetch(:name)
    assert name_errors.include?(subject::BLANK_ERROR)
  end

  test "zone is blank" do
    record = Record.new(name: "subdomain")
    record.valid?
    name_errors = record.errors.messages.fetch(:name)
    assert name_errors.include?(subject::ZONE_BLANK_ERROR)
  end

  test "zone domain name is blank" do
    record = Record.new(name: "subdomain", zone: Zone.new())
    record.valid?
    name_errors = record.errors.messages.fetch(:name)
    assert name_errors.include?(subject::ZONE_BLANK_DOMAIN_NAME_ERROR)
  end
end
