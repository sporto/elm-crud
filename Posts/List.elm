module Posts.List where

import Html
import Posts.Post as Post

view: Post.PostResults -> Html.Html
view result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok posts ->
      Html.table [] [
        Html.tbody [] (rows posts)
      ]

rows: (List Post.Model) -> (List Html.Html)
rows posts =
  List.map rowView posts

rowView: Post.Model -> Html.Html
rowView post =
  Html.tr [] [
    Html.td [] [ Html.text (toString post.id) ],
    Html.td [] [ Html.text post.title ],
    Html.td [] [
      Html.button [  ] [ Html.text "Reverse" ]
    ]
  ]
