require 'gibberish'
require 'cgi'

HOMEPAGE = Page.new(
  page: %{
  <html>
  <head>
    <title>Welcome</title>
    <meta http-equiv="refresh" content="10">
  </head>
  <body>
  <% if first && last %>
    <h1>Hello %first %last!</h1>
  <%else%>
    <h1>Hello World!</h1>
  <%end%>
    <p>Welcome to the world's simplest Web Server.</p>
    <p><img src='http://i.imgur.com/A3crbYQ.gif'></p>
    <ul>
      %user_list
    </ul>
  </body>
  </html>
  },
  code: 200, resource: "/home", http_method: "GET",
  modifiers: [%{
    parameters['user_list'] = USER_TABLE.map { |key, value| "<li>" + CGI::escapeHTML(value.username) + "</li>" }.join('') }])

ERROR_PAGE = Page.new(
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

PROFILE = Page.new(
  page: %{
  <html>
  <head>
    <% if username %>
      <title><%= username %>'s Profile Page</title>
    <%else%>
      <title>Profile Page</title>
    <%end%>
  </head>
  <body>
  <%if username %>
    Hello <%= username %>!
    <p>This is my profile page. Username: Matt Baker</p>
    <blockquote>Favorite Quote:
    <br>
    There is science, logic, reason; there is thought verified by experience.And then there is California. --Edward Abbey
  <%else%>
    You are not logged in. We're redirecting you to /login!
  <%end%>
  </body>
  </html>
  },
  code: 200, resource: "/profile",
  modifiers: ["
    user_account = User.find_by_user_id(cookie_hash['user_id'])
    if user_account
      parameters['username'] = CGI::escapeHTML(user_account.username)
    end"],http_method: "GET", redirect_criteria: "user_account = User.find_by_user_id(cookie_hash['user_id']); !user_account", redirect_url: "http://localhost:2000/login")

VISITS = Page.new(
    page: %{
      <html>
      <head>
        <title>Visit count</title>
      </head>
      <body>
        <p>You have visited %count times using this specific browser.</p>
      <% if loggedIn %>
        <p>When logged into this account, you visited %user_visits times, using different browsers.</P>
      <%end%>
      </body>
      </html>
      },
    code: 200, resource:"/visits",
    modifiers: ["cookie_hash['count'] += 1;
      user_account = User.find_by_user_id(cookie_hash['user_id'])
      if user_account
        parameters['loggedIn'] = true
        user_account.visits += 1
        cookie_hash['user_visits'] = user_account.visits
      end
    "], http_method: "GET")

LOGIN_PAGE_POST = Page.new(
  page: %{
    <html>
    <head>
      <title>Login!</title>
    <body>
      <% if loggedIn %>
        You are ready to RSPEC RAILS!
      <%else%>
        Try again later.
      <%end%>
    </body>
    </html>
    },
    code: 200, resource: "/login",
    modifiers: ["
      username = parameters['user']
      user_account = USER_TABLE[username]
      if (user_account && user_account.password == parameters['password'])
        cookie_hash['user_id'] = user_account.user_id
        parameters['loggedIn'] = true
      else
        parameters['loggedIn'] = false
      end"], http_method: "POST")

LOGIN_PAGE_GET = Page.new(
  page: %{
    <html>
    <head>
      <title>Let's Login!</title>
    </head>
    <body>
      For years, people have always asked for a form. After a billion dollars in investment, we have finally created a login form, and moved our website to the 1990s! So today, let's login!
      <form action="/login" method="POST">
        <label for="user">Username</label>
        <input type="text" name="user">
        <label for="password">Super-Secret Password</label>
        <input type="password" name="password">
        <input type="submit" value="Submit">
      </form>
    </body>
  </html>
  }, code:200, resource: "/login",
  http_method: "GET"
  )

REGISTER_PAGE_GET = Page.new(
  page: %{
    <html>
      <head><title>Register</title></head>
      <body>
      Here is a form that will allow you to make an account. 
      <form action="/register" method="POST">
        <label for="user">Username</label>
        <input type="text" name="user">
        <label for="password">Super-Secret Password</label>
        <input type="password" name="password">
        <input type="submit" value="Submit">
      </form>
    </html>
    }, code: 200, resource: "/register",
    http_method: "GET"
    )

REGISTER_PAGE_POST = Page.new(
  page: %{
    <html>
    <head>
    <% if registered %>
      <title>REGISTERED!</title>
    <%else%>
      <title>SORRY!</title>
    <%end%>
    </head>
    <body>
      <% if registered %>
        You are now registered! Please login using your new username and password!
      <% else %>
        The username was already taken. Please try again later.
      <%end%>
    }, code: 200, resource: "/register",
    modifiers: ["
      username = parameters['user']
      user_account = USER_TABLE[username]
      if user_account
        parameters['registered'] = false
      else
        User.create_user(parameters['user'], parameters['password'])
        parameters['registered'] = true
      end
    "],  http_method: "POST")

SECRET_KEY = "my secret key"
CIPHER = Gibberish::AES.new(SECRET_KEY)
