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

type alias Model = {
  fetches: Int,
  result: Result Http.Error (List Post.Model)
}

type Action
  = FetchPosts
  | PostsFechSuccess (Result Http.Error (List Post.Model))

model: Model
model =
  Model 0 (Ok [])

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FetchPosts ->
      Debug.log "FetchPosts"
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

postDecoder: Json.Decode.Decoder Post.Model
postDecoder =
  Json.Decode.object2 Post.Model
    ("id" := Json.Decode.int)
    ("title" := Json.Decode.string)

postsUrl: String
postsUrl =
  "http://jsonplaceholder.typicode.com/posts/"

