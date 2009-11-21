module Rocket
  class Policy < EM::Connection
    @@quiet = false
    @@policy_content = ''

    def self.start(host='127.0.0.1', port=843, file=nil ) # {{{
      if file.nil?
        STDERR.puts "Fatal : please specify flashxmlpolicy.xml"
        exit
      end
      read_file(file)
      STDERR.puts "EM start server invoke!"
      STDERR.puts "host: #{host} port: #{port.to_s}"
      EM.start_server(host, port, self)
    end # }}}

    def post_init
      STDERR.puts "post_init."
    end

    def receive_data data
      $/ = [0].pack('c')
      data.chomp!
      if data == '<policy-file-request/>'
        STDERR.puts "Received valid policy request."
        send_data @@policy_content
        send_data [0].pack('c')
      end
    end

    private

    def self.read_file(filepath)# {{{
      begin
        @@policy_content = IO.read(filepath)
      rescue => e
        STDERR.puts e
        e.backtrace.each do |b|
          STDERR.puts b 
        end
        exit
      end
    end# }}}

  end
end
