require_relative 'server'
require_relative 'pages'

homepage = Page.new(
	page: %{
	<html>
	<head>
		<title>Welcome</title>
	</head>
	<body>
	<% if first && last %>
		<h1>Hello %first %last!</h1>
	<%else%>
		<h1>Hello World!</h1>
	<%end%>
		<p>Welcome to the world's simplest Web Server.</p>
		<p><img src='http://i.imgur.com/A3crbYQ.gif'></p>
	</body>
	</html>
	},
	code: 200, resource: "/home", default_parameters: {"first" => "World!", "last" => ""})

error_page = Page.new(
	page: %{
	<html>
	<head>
  		<title>404 Error Page</title>
	</head>
	<body>
  		<strong><p>This is my 404 error page.</p></strong>
	</body>
	</html>
	},
	code: 404, resource: nil)

profile = Page.new(
	page: %{
	<html>
	<head>
	  <title>My Profile Page</title>
	</head>
	<body>
	  <p>This is my profile page. Username: Matt Baker</p>
    <blockquote>Favorite Quote:
    <br>
    There is science, logic, reason; there is thought verified by experience.And then there is California. --Edward Abbey
	</body>
	</html>
	},
	code: 200, resource: "/profile")


server = Server.new(2000, [homepage, profile], error_page)

loop do
	server.start
	server.send_message
	server.stop
end