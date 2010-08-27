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
          # For now use dynamic traits...
          traits = {
                    :class_name => RocketAMF::ClassMapper.get_as_class_name(@model),
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