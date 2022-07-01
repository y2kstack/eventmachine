

require 'rubygems'
require 'eventmachine'



class EchoServer < EM::Connection
    
    def post_init
        puts "New connection from #{}"
    end


    def receive_data(data)
        puts "Received data: #{data}"
        send_data(data)
    end


    def unbind
        puts "Connection closed"
    end

end


EM.run do
    EM.start_server("localhost", 8080, EchoServer)
    puts "Server started"
end