module Players.List exposing (..)


import RemoteData exposing (WebData)
import Html exposing (..)
import Material
import Material.Color as Color
import Material.Options as Options
import Material.Typography as Typo
import Material.Table as Table
import Material.Button as Button
import Material.Icon as Icon

import Msgs exposing (Msg)
import Models exposing (Player)
import Routing exposing (playerPath)


view : Material.Model -> WebData (List Player) -> Html Msg
view mdl response =
    div []
        [ heading
        , maybeList mdl response
        ]


heading : Html Msg
heading =
    Options.styled h2
        [ Typo.title, Color.text Color.primary ]
        [ text "Players" ]

maybeList : Material.Model -> WebData (List Player) -> Html Msg
maybeList mdl response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            list mdl players

        RemoteData.Failure error ->
            text (toString error)


list : Material.Model -> List Player -> Html Msg
list mdl players =
    Table.table []
        [ Table.thead []
              [ Table.tr []
                    [ Table.th [] [ text "Id" ]
                    , Table.th [] [ text "Name" ]
                    , Table.th [] [ text "Level" ]
                    , Table.th [] [ text "Actions" ]
                    ]
              ]
        , Table.tbody [] (List.map (playerRow mdl) players)
        ]


playerRow : Material.Model -> Player -> Html Msg
playerRow mdl player =
    Table.tr []
        [ Table.td [] [ text player.id ]
        , Table.td [] [ text player.name ]
        , Table.td [] [ text (toString player.level) ]
        , Table.td []
            [ editBtn mdl player ]
        ]

editBtn : Material.Model -> Player -> Html Msg
editBtn mdl player =
    let path = playerPath player.id
        idx = String.toInt player.id |> Result.toMaybe |> Maybe.withDefault 0
    in
        Button.render Msgs.Mdl [idx] mdl
            [ Button.icon
            , Button.ripple
            , Button.link path ]
            [ Icon.i "edit" ]
