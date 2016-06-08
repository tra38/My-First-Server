HOMEPAGE = Page.new(
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
  code: 200, resource: "/home", http_method: "GET")

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
  code: 200, resource: "/profile", http_method: "GET")

VISITS = Page.new(
    page: %{
      <html>
      <head>
        <title>Visit count</title>
      </head>
      <body>
        <p>You have visited %count times using this specific browser.</p>
      <% if user_id %>
        <p>When logged into this account, you visited %user_visits times, using different browsers.</P>
      <%end%>
      </body>
      </html>
      },
    code: 200, resource:"/visits",
    modifiers: ["cookie_hash['count'] += 1;
      user_account = User.find_by_user_id(cookie_hash['user_id'])
      if user_account
        user_account.visits += 1
        cookie_hash['user_visits'] = user_account.visits
      end
    "], http_method: "GET")

LOGIN_PAGE = Page.new(
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
