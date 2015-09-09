module Posts.ListLoader where

import Posts.List as List
import Posts.Post as Post
import Html
import Html.Events
import Http
import Effects exposing (Effects, Never)
import Debug
import Task
import Json.Decode exposing ((:=))

type Action
  = FetchPosts
  | PostsFechSuccess (Result Http.Error (List Post.Model))
  | PostChange List.Action

model: Post.PostList
model =
  Post.PostList 0 (Ok [])

update: Action -> Post.PostList -> (Post.PostList, Effects Action)
update action model =
  case action of
    FetchPosts ->
      Debug.log "FetchPosts"
      ({model | fetches <- model.fetches + 1}, fetchPosts)
    PostsFechSuccess result ->
      (
        Post.PostList model.fetches result,
        Effects.none
      )

view: Signal.Address Action -> Post.PostList -> Html.Html
view address model =
  Html.div [] [
    Html.button [ Html.Events.onClick address FetchPosts ] [ Html.text "Fetch Post" ],
    Html.text (toString model.fetches),
    List.view (Signal.forwardTo address PostChange) model.result
  ]

fetchPosts: Effects Action
fetchPosts =
  Http.get (Json.Decode.list postDecoder) (Http.url postsUrl [])
    |> Task.toResult
    |> Task.map PostsFechSuccess
    |> Effects.task

--(:=) = Json.Decode.(:=)

postDecoder: Json.Decode.Decoder Post.Model
postDecoder =
  Json.Decode.object2 Post.Model
    ("id" := Json.Decode.int)
    ("title" := Json.Decode.string)

postsUrl: String
postsUrl =
  "http://jsonplaceholder.typicode.com/posts/"

