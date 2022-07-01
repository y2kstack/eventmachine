
require 'eventmachine'
require 'logger'

class EchoClient < EM::Connection
    attr_accessor :connected

    @@logger = Logger.new(STDOUT)

    def post_init
        puts "New connection from #{}"
    end


    def connection_completed
        @@logger.info "Connection completed"
        connected = true
    end


    def receive_data(data)
        puts "Received data: #{data}"
        send_data(data)
    end

    def unbind
        @@logger.info "Connection closed"
        connected = false

        unless connected
            @@logger.info "Reconnecting..."

            @timer = EventMachine.add_timer(5) do
                EventMachine.connect("localhost", 8080, EchoClient)
            end
        end
    end

    def cleanup
        if @timer
            EventMachine.cancel_timer(@timer)
        end
    end
end


EM.run do
    EM.connect("localhost", 8080, EchoClient)
    puts "Client started"
end





















