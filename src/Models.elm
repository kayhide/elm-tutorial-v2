module Models exposing (..)

import RemoteData exposing (WebData)
import Material
import Material.Snackbar as Snackbar


type alias Model =
    { route : Route
    , mdl : Material.Model
    , snackbar : Snackbar.Model String
    , notices : List Notice
    , players : WebData (List Player)
    , editing : Maybe (Player, Player)
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , mdl = Material.model
    , snackbar = Snackbar.model
    , notices = []
    , players = RemoteData.Loading
    , editing = Nothing
    }


type alias PlayerId =
    String

type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }

type Notice
    = Info String
    | Alert String


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute
