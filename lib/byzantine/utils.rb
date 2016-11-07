module Byzantine
  module Utils
    def demodulize(path)
      path = path.to_s
      i = path.rindex '::'
      i ? path[(i + 2)..-1] : path
    end; module_function :demodulize
  end
end
