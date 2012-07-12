require 'celluloid/io'

class EchoServer
  include Celluloid::IO
  include Celluloid::Logger

  def initialize(host, port)
    info "*** Starting echo server on #{host}:#{port}"

    # Since we included Celluloid::IO, we're actually making a
    # Celluloid::IO::TCPServer here
    @server = TCPServer.new(host, port)
    run!
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { handle_connection! @server.accept }
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    debug "*** Received connection from #{host}:#{port}"
    loop { socket.write socket.readpartial(4096) }
  rescue EOFError
    debug "*** #{host}:#{port} disconnected"
  end
end

trap("INT") { exit }
EchoServer.new "localhost", 10001
sleep
