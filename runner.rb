require_relative 'server'
require_relative 'pages'
require_relative 'users'
require_relative 'web-finger2'

server = Server.new(2000, [HOMEPAGE, PROFILE, VISITS, LOGIN_PAGE], ERROR_PAGE)
puts "Server starting"
loop do
	server.start
	server.send_message
	server.stop
end