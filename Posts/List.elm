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
              { item | title <- (String.reverse item.title) }
            itemMapper item =
              if item.id == id then
                (
                  (updateItem item),
                  Post.savePost (updateItem item)
                )
              else
                (item, Effects.none)
            (updatedItems, fxList) =
              posts
                |> List.map itemMapper
                |> List.unzip
          in
            ((Ok updatedItems), Effects.batch fxList)
    Post.UpdateSuccess result ->
      (model, Effects.none)

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
