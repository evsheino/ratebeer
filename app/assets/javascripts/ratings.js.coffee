showTopUsers = ->
  USERS = {}

  table = $("#top-users")
  if table.length > 0
    $.getJSON 'top_users.json', (users) ->
      USERS.list = users
      for user in USERS.list
        $("#top-users").append(
          '<tr>'+
            '<td>'+user['username']+'</td>'+
            '<td>'+user['favorite_beer']['name']+'</td>'+
            '<td>'+user['favorite_brewery']['name']+'</td>'+
            '<td>'+user['favorite_style']['name']+'</td>'+
            '<td>'+user['rating_count']+'</td>'+
          '</tr>')
      $("#users-loading").hide()

$(document).on "page:change", -> showTopUsers()
$ -> showTopUsers()
