module Byzantine
  module Roles
    class Getter < BaseRole
      def call
        data_store.get message.key
      end
    end
  end
end
