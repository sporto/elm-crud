module Posts.List where

import Html
import Html.Events
import Posts.Post as Post

type Action
  = Reverse

view: Signal.Address Action -> Post.PostResults -> Html.Html
view address result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok posts ->
      Html.table [] [
        Html.tbody [] (rows address posts)
      ]

rows: Signal.Address Action -> (List Post.Model) -> (List Html.Html)
rows address posts =
  List.map (rowView address) posts

rowView: Signal.Address Action -> Post.Model -> Html.Html
rowView address post =
  Html.tr [] [
    Html.td [] [ Html.text (toString post.id) ],
    Html.td [] [ Html.text post.title ],
    Html.td [] [
      Html.button [ ] [ Html.text "Reverse" ]
    ]
  ]
