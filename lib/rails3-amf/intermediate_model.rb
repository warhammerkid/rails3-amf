module Rails3AMF
  class IntermediateModel
    TRAIT_CACHE = {}

    def initialize model, props
      @model = model
      @props = props.inject({}) {|out, (k,v)| out[k.to_s] = v; out}
    end

    def encode_amf serializer
      if serializer.version == 0
        if serializer.ref_cache[@model] != nil
          serializer.write_reference serializer.ref_cache[@model]
        else
          serializer.write_custom_object @model, @props
        end
      elsif serializer.version == 3
        # Use traits to reduce overhead
        unless traits = TRAIT_CACHE[@model.class]
          # Auto-map class name if enabled
          class_name = RocketAMF::ClassMapper.get_as_class_name(@model)
          if Rails3AMF::Configuration.auto_class_mapping && class_name.nil?
            class_name = @model.class.name
            RocketAMF::ClassMapper.define {|m| m.map :as => class_name, :rb => class_name}
          end

          # For now use dynamic traits...
          # members must be symbols in Ruby 1.9 and strings in Ruby 1.8
          traits = {
            :class_name => class_name,
            :members => [],
            :externalizable => false,
            :dynamic => true
          }
          TRAIT_CACHE[@model.class] = traits
        end
        serializer.write_custom_object @model, @props, traits
      end
    end
  end
end