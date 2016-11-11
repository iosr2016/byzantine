require 'securerandom'

module Byzantine
  class SequenceGenerator
    MAX_NUMBER = 1_000

    def initialize(base_number: nil)
      @base_number = base_number
    end

    def generate_number
      return @base_number + 1 if @base_number

      SecureRandom.random_number MAX_NUMBER
    end
  end
end
