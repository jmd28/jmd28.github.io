module Utils exposing (..)
import Html exposing (Html, node)
import Html.Attributes exposing (rel, href, src)
import Bootstrap.Form.Input exposing (number)

-- helper to load a css file into the project
loadStylesheet : String -> Html msg
loadStylesheet path = node "link" 
                  [ rel "stylesheet"
                  , href path
                  ] 
                  []

loadScript : String -> Html msg
loadScript path = node "script" [ src path] []

-- take a year, return millis between midnights of 1/1/year and 1/1/1970 
yearToUnix : Int -> Float
yearToUnix y = toFloat (y - 1970) * 365.25 * (24 * 60 * 60 * 1000)