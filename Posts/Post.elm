module Posts.Post where

import Effects exposing (Effects, Never)
import Json.Decode exposing ((:=))
import Json.Encode
import Http
import Task

type alias Model = {
  id: Int,
  title: String
}

type alias PostResults = Result Http.Error (List Model)

type alias PostList = {
  fetches: Int,
  result: PostResults
}

-- Individual actions for a post
type Action
  = Reverse Int
  | UpdateSuccess (Result Http.Error Model)

savePost: Model -> Effects Action
savePost model =
  savePostRequest model
    |> Http.fromJson postDecoder
    |> Task.toResult
    |> Task.map UpdateSuccess
    |> Effects.task

postDecoder: Json.Decode.Decoder Model
postDecoder =
  Json.Decode.object2 Model
    ("id" := Json.Decode.int)
    ("title" := Json.Decode.string)

savePostRequest: Model -> Task.Task Http.RawError Http.Response
savePostRequest model =
  Http.send Http.defaultSettings
    {
      verb = "PATCH",
      headers = [],
      url = savePostUrl model,
      body = Http.string (encodePostAsJson model)
    }

savePostUrl: Model -> String
savePostUrl model =
  "http://localhost:3000/posts/" ++ (toString model.id)

encodePostAsJson: Model -> String
encodePostAsJson model =
  Json.Encode.encode 0 (encodePost model)

encodePost: Model -> Json.Encode.Value
encodePost model =
  Json.Encode.object
    [
      ("id", Json.Encode.int model.id),
      ("title", Json.Encode.string model.title)
    ]
