module Posts.ListLoader where

import Posts.List as List
import Posts.Post as Post
import Html
import Html.Events
import Http
import Effects exposing (Effects, Never)
--import Debug
import Task
import Json.Decode exposing ((:=))

type alias Model = {
  fetches: Int,
  result: Result Http.Error (List Post.Post)
}

type Action
  = FetchPosts
  | PostsFechSuccess (Result Http.Error (List Post.Post))

model: Model
model =
  Model 0 (Ok [])

init: (Model, Effects Action)
init =
  (model, Effects.none)

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FetchPosts ->
      ({model | fetches <- model.fetches + 1}, fetchPosts)
    PostsFechSuccess result ->
      (
        Model model.fetches result,
        Effects.none
      )

view: Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div [] [
    Html.button [ Html.Events.onClick address FetchPosts ] [ Html.text "Fetch Post" ],
    Html.text (toString model.fetches),
    List.view model.result
  ]

fetchPosts: Effects Action
fetchPosts =
  Http.get (Json.Decode.list postDecoder) (Http.url postsUrl [])
    |> Task.toResult
    |> Task.map PostsFechSuccess
    |> Effects.task

--(:=) = Json.Decode.(:=)

postDecoder: Json.Decode.Decoder Post.Post
postDecoder =
  Json.Decode.object2 Post.Post
    ("id" := Json.Decode.int)
    ("title" := Json.Decode.string)

postsUrl: String
postsUrl =
  "http://jsonplaceholder.typicode.com/posts/"

