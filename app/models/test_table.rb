class TestTable < ActiveRecord::Base
  validate :column_to_object_valid?

  def column_to_object_valid?
    unless the_object.valid?
      errors.add(:the_object, the_object.errors.full_messages)
    end
  end

  def the_object
    @the_obj ||= TheObject.new(my_object)
  end
end

class TheObject
  include ActiveModel
  include ActiveModel::Validations

  validates :hi, presence: true

  def initialize(attributes)
    @json_values = attributes

    attributes.except("validations").each do |key, value|
      self.class.send(:attr_reader, key)
      instance_variable_set("@#{key}", value)
      define_method "#{key}=" do |arg|
        instance_variable_set("@#{key.clone}", arg)
        @json_values[key.clone] = arg
      end

      attributes["validations"].try(:[], key).try(:each) do |validation|
        self.class.send("validates_#{validation}", key)
      end
    end
  end
end
