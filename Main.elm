import Posts.ListLoader as PostsListLoader
import Posts.Post

import Html
import StartApp
import Effects exposing (Effects, Never)
import Task
import Debug

-- Main application model
type alias AppModel = {
  posts: PostsListLoader.Model
}

-- Initial model
model: AppModel
model =
  {
    posts = PostsListLoader.model
  }

type Action
  = DoNothing
  | PostsUpdate PostsListLoader.Action

init: (AppModel, Effects Action)
init =
  (model, Effects.none)

app =
  StartApp.start {
    init = init,
    update = update,
    view = view,
    inputs = []
  }

    --init = PostsListLoader.init,
    --update = PostsListLoader.update,
    --view = PostsListLoader.view,

main: Signal Html.Html
main =
  app.html

-- update
update: Action -> AppModel -> (AppModel, Effects Action)
update action appModel =
  case action of
    PostsUpdate postsAction ->
      let
        (updated, fx) = PostsListLoader.update postsAction appModel.posts
      in
        (
          {appModel | posts <- updated},
          Effects.map PostsUpdate fx
        )

-- view
view: Signal.Address Action -> AppModel -> Html.Html
view address appModel =
  Html.div [] [
    PostsListLoader.view (Signal.forwardTo address PostsUpdate) appModel.posts
  ]

-- this is the important bit
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
