module Main exposing (..)

import Html exposing (Html, text, input, div, Attribute)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { readOnly : Bool
    , someCheckbox : Bool
    }


init : ( Model, Cmd Msg )
init =
    Model False False ! []


type Msg
    = ReadOnlyToggle
    | SomeCheckboxToggle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReadOnlyToggle ->
            { model | readOnly = not model.readOnly } ! []

        SomeCheckboxToggle ->
            { model
                | someCheckbox =
                    if model.readOnly then
                        model.someCheckbox
                    else
                        not model.someCheckbox
            }
                ! []


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ text "read only"
            , input
                [ type_ "checkbox"
                , checked model.readOnly
                , onClick ReadOnlyToggle
                ]
                []
            ]
        , div []
            [ text "some checkbox"
            , input
                [ type_ "checkbox"
                , checked model.someCheckbox
                , onClickPreventDefault SomeCheckboxToggle
                ]
                []
            ]
        ]


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault message =
    let
        config =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions "click" config (Json.succeed message)
