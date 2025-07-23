if defined?(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.class_eval do
    def regexp(a, b)
      return false if b.nil?
      /#{a}/i.match?(b.to_s)
    end
  end

  ActiveRecord::Base.connection.raw_connection.create_function("regexp", 2) do |pattern, value|
    begin
      Regexp.new(pattern.to_s).match?(value.to_s)
    rescue RegexpError
      false
    end
  end
end
