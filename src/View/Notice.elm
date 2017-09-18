module View.Notice exposing (..)

import Html exposing (Html, div, p, a, text, i)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Msgs exposing (Msg)
import Models exposing (Model, Notice(..))


render : Model -> Html Msg
render model =
    model.notices
        |> List.indexedMap renderItem
        |> div []

renderItem : Int -> Notice -> Html Msg
renderItem idx notice =
    case notice of
        Info x ->
            div [ class "clearfix m1 p1 blue bg-aqua border-blue rounded" ]
                [ text x
                , a [ class "right btn p0", onClick (Msgs.CloseNotice idx) ]
                    [ i [ class "fa fa-times" ] [] ]
                ]

        Alert x ->
            div [ class "clearfix m1 p1 maroon bg-orange border-red rounded" ]
                [ text x
                , a [ class "right btn p0", onClick (Msgs.CloseNotice idx) ]
                    [ i [ class "fa fa-times" ] [] ]
                ]
