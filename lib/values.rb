class Value
  def self.new(*fields)
    return Class.new do
      attr_reader *fields

      define_method(:initialize) do |*input_fields|
        raise ArgumentError.new("wrong number of arguments, #{input_fields.size} for #{fields.size}") if fields.size != input_fields.size

        fields.each_with_index do |field, index|
          instance_variable_set('@' + field.to_s, input_fields[index])
        end
        self.freeze
      end

      const_set :VALUE_ATTRS, fields

      def ==(other)
        self.eql?(other)
      end

      def eql?(other)
        return false if other.class != self.class
        self.class::VALUE_ATTRS.all? do |field|
          self.send(field) == other.send(field)
        end
      end

      def hash
        hash_factors = [self.class.hash]
        hash_factors << self.class::VALUE_ATTRS.map do |field|
          self.send(field)
	end
        hash_factors.hash
      end
    end
  end
end
