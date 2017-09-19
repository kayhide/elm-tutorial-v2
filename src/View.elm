module View exposing (..)

import RemoteData
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Material.Layout as Layout
import Material.Snackbar as Snackbar

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
        , Snackbar.view model.snackbar |> Html.map Msgs.Snackbar
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
            case model.editing of
                Just editing ->
                    Players.Edit.view model.mdl editing

                Nothing ->
                    notFoundView

        RemoteData.Failure error ->
            text (toString error)

notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not Found" ]
