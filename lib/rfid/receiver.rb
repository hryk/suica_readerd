require 'logger'
require 'json'
require 'socket'

require 'sinatra'
require 'nfc'
require 'statemachine'

module RFID
  CRLF = "\x0D\x0A"
  class Receiver < ::Sinatra::Application
    @@logger = nil;
    @@baseid = IO.read(::BASE_ID_PATH).chomp

    def self.baseid; @@baseid;end

    set :host , "127.0.0.1"
    set :port , 5000
    set :server, 'mongrel'

    #    def initialize(option={}, &block)# {{{
    #      STDERR.puts "initialize!"
    #      if block
    #        STDERR.puts "initialize!"
    #        block.call
    #      end
    #      @@logger = Logger.new File.join(options.root, 'tmp', 'rfid.log')
    #      super(option)
    #    end# }}}

    at_exit {
      ::NFC.instance.device.disconnect()
    }

    error do
      STDERR.puts request.query_string()
    end

    get '/' do
      STDERR.puts "request !"
      response['Content-Type'] =  'text/plain'
      NFCResponse.new
    end

    private

    def read_rfid
      rfid = nil
      ::NFC.instance.find do |tag|
        rfid = tag.to_s '-'
        if rfid
          break
        end
      end
      rfid
    end
  end

  class RFIDReceiverContext
    def send_rfid(rfid)
      STDERR.puts "RFID Send! #{rfid}"
    end

    def continue_login
      STDERR.puts "already logged in"
    end

    def send_logout
      STDERR.puts "Loggout!"
    end
  end

  class NFCResponse
    attr_accessor :maton

    def initialize 
      @maton =  ::Statemachine.build do
        state :waiting do
          event :get_rfid, :logged_in, :send_rfid
        end

        state :logged_in do
          event :get_rfid, :logged_in, :continue_login
          event :leave_rfid, :waiting, :send_logout
        end
        context RFIDReceiverContext.new
      end
    end

    def each
      rfid_old = nil
      rfid = nil

      loop do
#        STDERR.puts "loop start : state -> " + @maton.state.to_s
        begin
          tag = NFC.instance.find
        rescue => e
        end
        rfid = tag.to_s
        if rfid == 'false' && @maton.state == :logged_in
          @maton.leave_rfid
          res = {}
          res[:uuid] = 'undefined'
          res[:location] = RFID::Receiver.baseid
          res[:time] = DateTime.now
          res[:action] = 'logout'
          yield res.to_json + CRLF
        elsif rfid != 'false' && @maton.state == :waiting
          @maton.get_rfid rfid
          res = {}
          res[:uuid] = rfid
          res[:location] = RFID::Receiver.baseid
          res[:time] = DateTime.now
          res[:action] = 'login'
          yield res.to_json + CRLF
        else
#          STDERR.puts "waiting...."
        end
      end
    end

  end
end


