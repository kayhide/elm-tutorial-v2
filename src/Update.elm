module Update exposing (..)

import RemoteData exposing (WebData)

import Msgs exposing (Msg(..))
import Commands exposing (savePlayerCmd)
import Models exposing (Model, Notice(..), Player)
import Routing exposing (parseLocation)


noticeRemoteDataResponse : Model -> RemoteData.RemoteData e a -> List Notice
noticeRemoteDataResponse model data =
    case data of
        RemoteData.Loading ->
            Info "Loading..." :: model.notices

        RemoteData.Failure error ->
            Alert (toString error) :: model.notices

        _ ->
            model.notices


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ({ model |
               notices = noticeRemoteDataResponse model response
             , players = response
             }, Cmd.none)

        Msgs.OnLocationChange location ->
            let newRoute = parseLocation location
            in
                ({ model | route = newRoute, editing = Nothing }, Cmd.none)

        Msgs.CloseNotice i ->
            let newNotices =
                    model.notices
                        |> List.indexedMap (,)
                        |> List.filter (Tuple.first >> (/=) i)
                        |> List.map Tuple.second
            in
                ({ model | notices = newNotices }, Cmd.none)

        Msgs.ChangeLevel player x ->
            let updatedPlayer =
                    { player | level = player.level + x }
            in
                (model, savePlayerCmd updatedPlayer)

        Msgs.OnPlayerSave (Ok player) ->
            let info = Info "Updated the player."
            in
                ({ model |
                   notices = info :: model.notices
                 , players = updatePlayer model player
                 }, Cmd.none)

        Msgs.OnPlayerSave (Err error) ->
            let alert = Alert "Failed to save the player."
            in
                ({ model | notices = alert :: model.notices }, Cmd.none)

        Msgs.ChangingName player x ->
            let newEditing = Just (player, { player | name = x })
            in
                ({ model | editing = newEditing }, Cmd.none)

        Msgs.ChangePlayer player ->
            (model, savePlayerCmd player)


updatePlayer : Model -> Player -> WebData (List Player)
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer

        updatePlayerList players =
            List.map pick players
    in
        RemoteData.map updatePlayerList model.players
