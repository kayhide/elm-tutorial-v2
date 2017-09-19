module View exposing (..)

import RemoteData
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Material.Layout as Layout

import Msgs exposing (Msg)
import Models exposing (Model, Player, PlayerId)
import Players.List
import Players.Edit
import View.Notice


view : Model -> Html Msg
view model =
    Layout.render Msgs.Mdl model.mdl
        [ Layout.fixedHeader ]
        { header = [ renderHeader model ]
        , drawer = []
        , tabs = ([], [])
        , main = [renderBody model]
        }

renderHeader : Model -> Html Msg
renderHeader model =
    Layout.row []
        [ Layout.title [] [ text "Tutorial" ] ]

renderBody : Model -> Html Msg
renderBody model =
    div [ class "px2" ]
        [ View.Notice.render model
        , page model
        ]

page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Players.List.view model.mdl model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            let maybePlayer =
                    players
                        |> List.filter (.id >> (==) playerId)
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        Maybe.withDefault (player, player) model.editing
                            |> Players.Edit.view model.mdl

                    Nothing ->
                        notFoundView

        RemoteData.Failure error ->
            text (toString error)

notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not Found" ]
