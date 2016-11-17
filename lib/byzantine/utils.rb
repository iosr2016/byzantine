module Byzantine
  module Utils
    def demodulize(path)
      path = path.to_s
      i = path.rindex '::'
      i ? path[(i + 2)..-1] : path
    end; module_function :demodulize

    def symbolize_keys(hash)
      Hash[hash.map { |key, val| [key.to_sym, val] }]
    end; module_function :symbolize_keys
  end
end
