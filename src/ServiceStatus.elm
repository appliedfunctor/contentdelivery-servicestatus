module ServiceStatus exposing (main)

import Html exposing (div, h1, img, text)
import Html.Attributes exposing (..)
import Http
import Browser

type alias Service = 
    { code : String
    , name : String
    , healthcheckUrl : Url
    }

type alias Url = 
    { path : String
    , prt : Int
    }

newUrl : String -> Maybe Int -> Url
newUrl pathString portString = 
    { path = pathString
    , prt = case portString of
        Nothing -> 80

        Just prt -> prt
    }

type Msg
    = LoadHealthcheck (Result Http.Error String)


view model =
    div [ class "content" ]
        [ h1 [] [ text "Content Delivery Service Status" ] ]

prdServiceData : List Service
prdServiceData = 
    [
        { code = "BMS"
        , name = "Bundle Metadata Service"
        , healthcheckUrl = newUrl "http://bms.aeuw1.prd.cd.itvcloud.zone/_meta/healthcheck" Nothing
        }
    ]

initialModel = 
    {
        services = prdServiceData
    }

update msg model = 
    model

loadHCData : Service -> Msg
loadHCData service = 
    service.healthcheckUrl
        |> Http.getString
        |> Http.send LoadHealthcheck

initialCmd : Cmd Msg
initialCmd =
    List.map (\data -> LoadHCData data) prdServiceData
        

main =
    Browser.sandbox
    {   init = initialModel
      , view = view
      , update = update
    }
