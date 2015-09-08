module Posts.ListLoader where

import Posts.List as List
import Html
import Html.Events
import Http
import StartApp
import Effects exposing (Effects, Never)
import Debug
import Task
import Json.Decode

type alias Model = {
  fetches: Int,
  result: Result Http.Error (List String)
}

type Action
  = FetchPosts
  | PostsFechSuccess (Result Http.Error (List String))

model: Model
model =
  Model 0 (Ok [""])

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
  Http.get (Json.Decode.list parsePost) (Http.url postsUrl [])
    |> Task.toResult
    |> Task.map PostsFechSuccess
    |> Effects.task

parsePost: Json.Decode.Decoder String
parsePost =
  Json.Decode.string

postsUrl: String
postsUrl =
  "http://jsonplaceholder.typicode.com/posts/"

