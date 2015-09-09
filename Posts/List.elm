module Posts.List where

import Html
import Http
import Posts.Post as Post

view: Result Http.Error (List Post.Post) -> Html.Html
view result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok posts ->
      Html.table [] [
        Html.tbody [] (rows posts)
      ]

rows: (List Post.Post) -> (List Html.Html)
rows posts =
  List.map rowView posts

rowView: Post.Post -> Html.Html
rowView post =
  Html.tr [] [
    Html.td [] [ Html.text (toString post.id) ],
    Html.td [] [
      Html.button [  ] [ Html.text post.title ]
    ]
  ]
