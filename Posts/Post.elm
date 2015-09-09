module Posts.Post where

import Http
import Effects exposing (Effects, Never)

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

savePost: Model -> Effects Action
savePost model =
  --Http.request "PATCH" 
  Effects.none
