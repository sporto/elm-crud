module Posts.List where

import Html
import Http

view: Result Http.Error String -> Html.Html
view result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok json ->
      Html.div [] [
        Html.text json
      ]

