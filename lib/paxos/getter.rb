module Paxos
  module Getter
    def get(key)
      data_store.get key
    end
  end
end
