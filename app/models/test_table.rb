class TestTable < ActiveRecord::Base
  validate do |test_table|
    the_object.valid?
  end

  def the_object
    @the_obj ||= TheObject.new(my_object)
  end
end

class TheObject
  include ActiveModel
  include ActiveModel::Validations

  def initialize(attributes)
    validations = attributes.delete("validations")

    attributes.each do |key, value|
      self.class.send(:attr_accessor, key)
      instance_variable_set("@#{key}", value)

      validations.try(:[], key).try(:each) do |validation|
        self.class.send("validates_#{validation}", key)
      end
    end
  end
end
