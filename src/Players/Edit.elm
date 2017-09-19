module Players.Edit exposing (..)

import Html exposing (..)
import Material
import Material.Color as Color
import Material.Options as Options
import Material.Typography as Typo
import Material.Button as Button
import Material.Icon as Icon
import Material.Textfield as Textfield

import Msgs exposing (Msg)
import Models exposing (Player)
import Routing exposing (playersPath)


type alias Editing = (Player, Player)

view : Material.Model -> Editing -> Html Msg
view mdl editing =
    div []
        [ heading mdl editing
        , form mdl editing
        ]


heading : Material.Model -> Editing -> Html Msg
heading mdl (player, _) =
    div []
        [ Button.render Msgs.Mdl [0] mdl
              [ Button.icon
              , Button.link playersPath ]
              [ Icon.i "chevron_left" ]
        , Options.styled h2
            [ Typo.title, Color.text Color.primary ]
            [ text player.name ]
        ]

form : Material.Model -> Editing -> Html Msg
form mdl editing =
    div []
        [ formName mdl editing
        , formLevel mdl editing
        , btnRevert mdl editing
        , btnSave mdl editing
        ]

formName : Material.Model -> Editing -> Html Msg
formName mdl (player, player_) =
    Textfield.render Msgs.Mdl [1] mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text_
        , Textfield.value player_.name
        , Options.onInput (Msgs.ChangingName player)
        ]
        []

btnRevert : Material.Model -> Editing -> Html Msg
btnRevert mdl (player, _) =
    Button.render Msgs.Mdl [2] mdl
        [ Button.raised
        , Button.ripple
        , Options.onClick <| Msgs.ChangePlayer player
        ]
        [ text "Revert" ]

btnSave : Material.Model -> Editing -> Html Msg
btnSave mdl (_, player_) =
    Button.render Msgs.Mdl [2] mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Options.onClick <| Msgs.ChangePlayer player_
        ]
        [ text "Save" ]

formLevel : Material.Model -> Editing -> Html Msg
formLevel mdl (_, player_) =
    div []
        [
         Textfield.render Msgs.Mdl [3] mdl
             [ Textfield.label "Level"
             , Textfield.floatingLabel
             , Textfield.text_
             , Textfield.value <| toString player_.level
             ]
             []
        , btnLevelDecrease mdl player_
        , btnLevelIncrease mdl player_
        ]


btnLevelDecrease : Material.Model -> Player -> Html Msg
btnLevelDecrease mdl player =
    Button.render Msgs.Mdl [4] mdl
        [ Button.icon
        , Button.colored
        , Button.ripple
        , Options.onClick <| Msgs.ChangeLevel player -1
        ]
        [ Icon.i "remove_circle" ]

btnLevelIncrease : Material.Model -> Player -> Html Msg
btnLevelIncrease mdl player =
    Button.render Msgs.Mdl [5] mdl
        [ Button.icon
        , Button.colored
        , Button.ripple
        , Options.onClick <| Msgs.ChangeLevel player 1
        ]
        [ Icon.i "add_circle" ]
