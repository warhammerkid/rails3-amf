require 'active_record'
require 'rails3-amf/intermediate_model'

module ActiveRecord
  module Serialization
    # Control the serialization of the model by specifying the relations, properties,
    # methods, and other data to serialize with the model. Parameters take the
    # same form as serializable_hash - see active record/active model serialization
    # for more details.
    #
    # If not serialized to an intermediate form before it reaches the AMF
    # serializer, it will be serialized with the default options.
    def to_amf options=nil
      options ||= {}

      options[:except] = Array.wrap(options[:except]).map { |n| n.to_s }
      options[:except] |= Array.wrap(self.class.inheritance_column)

      # Call serializable_hash from ActiveModel so that I can process associations
      # through to_amf, rather than ActiveRecord's serializable_hash
      base_serializable_hash = ActiveModel::Serialization.instance_method(:serializable_hash).bind(self)
      hash = base_serializable_hash.call options

      serializable_add_includes(options) do |association, records, opts|
        hash[association] = records.is_a?(Enumerable) ?
          records.map { |r| r.to_amf(opts) } :
          records.to_amf(opts)
      end

      Rails3AMF::IntermediateModel.new(self, hash)
    end

    # Called by serialization routines if the user did not use to_amf to convert
    # to an intermediate form prior to serialization. Encodes using the default
    # serialization settings.
    def encode_amf serializer
      self.to_amf.encode_amf serializer
    end
  end
end