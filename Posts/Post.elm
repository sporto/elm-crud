module Posts.Post where

import Http

type alias Model = {
  id: Int,
  title: String
}

type alias PostList = {
  fetches: Int,
  result: Result Http.Error (List Model)
}
