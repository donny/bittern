module Bittern
  enum MessageType
    ClientJoin
    ClientLeave
    ClientMessage
    Error
  end

  struct Message
    property mtype, content

    def initialize(@mtype : MessageType, @content = "")
    end

    def initialize(raw_string : String)
      @content = ""
      data = raw_string.split('|')

      case data[0]
      when "CLIENT_JOIN"
        @mtype = MessageType::ClientJoin
        @content = data[1]
      when "CLIENT_LEAVE"
        @mtype = MessageType::ClientLeave
      when "CLIENT_MESSAGE"
        @mtype = MessageType::ClientMessage
        @content = data[1]
      else
        @mtype = MessageType::Error
      end
    end

    def serialize
      case @mtype
      when MessageType::ClientJoin
        "CLIENT_JOIN|" + content + "\n"
      when MessageType::ClientLeave
        "CLIENT_LEAVE\n"
      when MessageType::ClientMessage
        "CLIENT_MESSAGE|" + content + "\n"
      else
        "ERROR\n"
      end
    end
  end
end
