import Posts.ListLoader as PostsListLoader

import Html
import Html.Events
import StartApp
import Effects exposing (Effects, Never)
import Task

app =
  StartApp.start {
    init = PostsListLoader.init,
    update = PostsListLoader.update,
    view = PostsListLoader.view,
    inputs = []
  }

main: Signal Html.Html
main =
  app.html

-- this is the important bit
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
