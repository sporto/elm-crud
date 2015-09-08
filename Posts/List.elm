module Posts.List where

import Html
import Http

view: Result Http.Error (List String) -> Html.Html
view result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok items ->
      Html.table [] [
        Html.tbody [] (rows items)
      ]

rows: (List String) -> (List Html.Html)
rows items =
  List.map rowView items

rowView: String -> Html.Html
rowView item =
  Html.tr [] [
    Html.td [] [ Html.text item ],
    Html.td [] [
      Html.button [  ] [ Html.text item ]
    ]
  ]
