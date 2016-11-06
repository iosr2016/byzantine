module Byzantine
  class SequenceGenerator
    MAX_NUMBER = 100_000

    def generate_number
      SecureRandom.random_number MAX_NUMBER
    end
  end
end
