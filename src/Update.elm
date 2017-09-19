module Update exposing (..)

import RemoteData exposing (WebData)
import Material

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

        Msgs.OnPlayerSave (Ok player) ->
            let info = Info "Updated the player."
            in
                ({ model |
                   notices = info :: model.notices
                 , players = updatePlayer model player
                 , editing = Nothing
                 }, Cmd.none)

        Msgs.OnPlayerSave (Err error) ->
            let alert = Alert "Failed to save the player."
            in
                ({ model | notices = alert :: model.notices }, Cmd.none)

        Msgs.ChangingName player x ->
            let f p = { p | name = x }
            in
                model |> ensureEditing player |> editPlayer f

        Msgs.ChangeLevel player x ->
            let f p = { p | level = p.level + x }
            in
                model |> ensureEditing player |> editPlayer f

        Msgs.ChangePlayer player ->
            (model, savePlayerCmd player)


        Msgs.Mdl msg_ ->
            Material.update Mdl msg_ model


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

ensureEditing : Player -> Model -> Model
ensureEditing player model =
    case model.editing of
        Just _ ->
            model

        Nothing ->
            { model | editing = Just (player, player) }

editPlayer : (Player -> Player) -> Model -> (Model, Cmd Msg)
editPlayer f model =
    case model.editing of
        Just (player, player_) ->
            ({ model | editing = Just (player, f player_) }, Cmd.none)

        Nothing ->
            (model, Cmd.none)
