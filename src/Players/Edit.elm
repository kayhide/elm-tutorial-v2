module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, type_, placeholder)
import Html.Events exposing (onClick, onInput)

import Msgs exposing (Msg)
import Models exposing (Player)
import Routing exposing (playersPath)


view : (Player, Player) -> Html Msg
view (player, editingPlayer) =
    div []
        [ nav player
        , form editingPlayer
        ]


nav : Player -> Html Msg
nav player =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]


form : Player -> Html Msg
form player =
    div [ class "m3" ]
        [ h1 [] [ text player.name ]
        , formName player
        , formLevel player
        ]

formName : Player -> Html Msg
formName player =
    div [ class "clearfix py1" ]
        [ div [ class "col col-5" ]
              [ input [ type_ "text"
                      , class "input"
                      , value player.name
                      , placeholder "Name"
                      , onInput (Msgs.ChangingName player) ] []
              , btnSave player
              ]
        ]

btnSave : Player -> Html Msg
btnSave player =
    let message =
            Msgs.ChangePlayer player
    in
        a [ class "btn btn-outline blue", onClick message ]
        [ text "Save" ]



formLevel : Player -> Html Msg
formLevel player =
    div [ class "clearfix py1" ]
        [ div [ class "col col-5" ] [ text "Level" ]
        , div [ class "col col-7" ]
            [ span [ class "h2 bold" ] [ text (toString player.level) ]
            , btnLevelDecrease player
            , btnLevelIncrease player
            ]
        ]


btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
    let message =
            Msgs.ChangeLevel player -1
    in
        a [ class "btn ml1 h1", onClick message ]
            [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
    let message =
            Msgs.ChangeLevel player 1
    in
        a [ class "btn ml1 h1", onClick message ]
        [ i [ class "fa fa-plus-circle" ] [] ]


listBtn : Html Msg
listBtn =
    a [ class "btn regular"
      , href playersPath
      ]
      [ i [ class "fa fa-chevron-left mr1" ] []
      , text "List"
      ]
