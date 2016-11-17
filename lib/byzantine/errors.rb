module Byzantine
  module Errors
    Standard            = Class.new StandardError
    UnknownMessageType  = Class.new Standard
  end
end
