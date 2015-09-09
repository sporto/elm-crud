module Posts.List where

import Html
import Html.Events
import Debug
import String
import Posts.Post as Post
import Effects exposing (Effects, Never)

{-
This component receives a list of Post.PostResults
  -}

update: Post.Action -> Post.PostResults -> (Post.PostResults, Effects Post.Action)
update action model =
  case action of
    Post.Reverse id ->
      case model of
        Ok posts ->
          let
            updateItem item =
              if item.id == id then
                (
                  { item | title <- (String.reverse item.title) },
                  Post.savePost item
                )
              else
                (item, Effects.none)
            (updatedItems, fxList) =
              posts
                |> List.map updateItem
                |> List.unzip
          in
            ((Ok updatedItems), Effects.batch fxList)

view: Signal.Address Post.Action -> Post.PostResults -> Html.Html
view address result =
  case result of
    Err error ->
      Html.text (toString result)
    Ok posts ->
      Html.table [] [
        Html.tbody [] (rows address posts)
      ]

rows: Signal.Address Post.Action -> (List Post.Model) -> (List Html.Html)
rows address posts =
  List.map (rowView address) posts

rowView: Signal.Address Post.Action -> Post.Model -> Html.Html
rowView address post =
  Html.tr [] [
    Html.td [] [ Html.text (toString post.id) ],
    Html.td [] [ Html.text post.title ],
    Html.td [] [
      Html.button [ Html.Events.onClick address (Post.Reverse post.id) ] [ Html.text "Reverse" ]
    ]
  ]
