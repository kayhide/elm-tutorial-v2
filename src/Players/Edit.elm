module Players.Edit exposing (..)

import Html exposing (..)
import Material
import Material.Color as Color
import Material.Options as Options
import Material.Typography as Typo
import Material.Button as Button
import Material.Icon as Icon
import Material.Textfield as Textfield
import Material.Grid exposing (grid, cell, size, stretch, Device(..), Align(..))

import Msgs exposing (Msg)
import Models exposing (Player)
import Routing exposing (playersPath)


type alias Editing = (Player, Player)

view : Material.Model -> Editing -> Html Msg
view mdl editing =
    div []
        [ heading mdl editing
        , form mdl editing
        , Button.render Msgs.Mdl [0] mdl
              [ Button.raised
              , Button.link playersPath ]
              [ Icon.i "chevron_left"
              , text "Back"
              ]
        ]


heading : Material.Model -> Editing -> Html Msg
heading mdl (player, _) =
    div []
        [ Options.styled h2
              [ Typo.title, Color.text Color.primary ]
              [ text player.name ]
        ]

form : Material.Model -> Editing -> Html Msg
form mdl editing =
    grid []
        [ cell [ size All 12 ] [ formName mdl editing ]
        , cell [ size All 12 ] [ formLevel mdl editing ]
        , cell [ size All 2 ] [ btnRevert mdl editing ]
        , cell [ size All 2 ] [ btnSave mdl editing ]
        ]

formName : Material.Model -> Editing -> Html Msg
formName mdl (player, player_) =
    Textfield.render Msgs.Mdl [1] mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text_
        , Textfield.value player_.name
        , Options.onInput Msgs.ChangeName
        ]
        []

btnRevert : Material.Model -> Editing -> Html Msg
btnRevert mdl _ =
    Button.render Msgs.Mdl [2, 0] mdl
        [ Button.raised
        , Button.ripple
        , Options.css "width" "100%"
        , Options.onClick Msgs.RevertPlayer
        ]
        [ text "Revert" ]

btnSave : Material.Model -> Editing -> Html Msg
btnSave mdl _ =
    Button.render Msgs.Mdl [2, 1] mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Options.css "width" "100%"
        , Options.onClick Msgs.SavePlayer
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
        , span []
            [ btnLevelDecrease mdl
            , btnLevelIncrease mdl
            ]
        ]


btnLevelDecrease : Material.Model -> Html Msg
btnLevelDecrease mdl =
    Button.render Msgs.Mdl [4, 0] mdl
        [ Button.icon
        , Button.colored
        , Button.ripple
        , Options.onClick <| Msgs.ChangeLevel -1
        ]
        [ Icon.i "remove_circle" ]

btnLevelIncrease : Material.Model -> Html Msg
btnLevelIncrease mdl =
    Button.render Msgs.Mdl [4, 1] mdl
        [ Button.icon
        , Button.colored
        , Button.ripple
        , Options.onClick <| Msgs.ChangeLevel 1
        ]
        [ Icon.i "add_circle" ]
