module Posts.Post where

import Http

type alias Model = {
  id: Int,
  title: String
}

type alias PostResults = Result Http.Error (List Model)

type alias PostList = {
  fetches: Int,
  result: PostResults
}
