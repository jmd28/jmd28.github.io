module Main exposing (..)

import Styles
import Data
import List
import Utils exposing (yearToUnix)

import Http
import Svg as S
import Time
import String exposing (toLower)

import Bootstrap.Accordion as Acc
import Bootstrap.Alert exposing (link)
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (containerFluid)
import Bootstrap.Grid.Col
import Bootstrap.Utilities.Spacing exposing (px4)

import Chart as C
import Chart.Attributes as CA

import Browser exposing (Document)

import Html exposing (..)
import Html.Attributes exposing (id, class, src, style)
import Html.Attributes exposing (href)
import Html.Attributes exposing (classList)
import Html.Attributes exposing (attribute)
import Html.Attributes exposing (type_)
import Html.Attributes exposing (target)
import Html.Attributes exposing (width)
import Html.Attributes exposing (height)
import Html.Events exposing (onClick)


type alias Tab = Int
type alias Model = { 
        title : String, 
        activeModuleTab : Tab,
        moduleAccordionState : Acc.State
    }

type Msg = ChangeTab Tab | ModulesAccordion Acc.State

treeimg : String
treeimg = "assets/img/bigboyplant.jpg"

main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

init : flags -> (Model, Cmd msg)
init _ = (
        { title = "James Diffley"
        , activeModuleTab = 4
        , moduleAccordionState = Acc.initialState
        }
        , Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of 
                    ChangeTab tab 
                        -> ({ model | activeModuleTab = tab }, Cmd.none)
                    ModulesAccordion state
                        -> ({ model | moduleAccordionState = state }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = 
    Acc.subscriptions model.moduleAccordionState ModulesAccordion

renderModuleTab : Model -> Tab -> Html Msg
renderModuleTab model tabnum = 
        li [ class "nav-item" ]
            [ a
                [ class "nav-link"
                , onClick (ChangeTab tabnum)
                , classList [ ( "active", model.activeModuleTab == tabnum ) ]
                ]
                [ h3 [] [ text ("Year " ++ String.fromInt tabnum) ] ]
            ]

renderModuleTabs : Model -> Html Msg
renderModuleTabs model = ul [ class "nav nav-tabs"  ]
                            (List.map (renderModuleTab model) [1,2,3,4])

-- renderModulesContent : Model -> Html Msg
-- renderModulesContent model = ul [] 
--                                 (List.map (\m -> li [class "mt-2"] [text m]) (Data.modules model.activeModuleTab))


-- getModuleData m = Http.get { expect = Http.expectString, url = "https://www.st-andrews.ac.uk/subjects/modules/catalogue/?code=CS3101&academic_year=2021/2" }

-- an accordion card which displays a summary of a module
moduleCard : Data.Module -> Acc.Card Msg
moduleCard m = Acc.card
                { id = m.title
                , options = [ Card.attrs [class "modulecard"]]
                , header =
                    Acc.header [] <| Acc.toggle [] [ text m.title ]
                , blocks =
                    [ Acc.block []
                        [ Block.text [style "font-size" "0.9rem"] [ text m.desc ] ]
                    ]
                }

moduleCards : Model -> List (Acc.Card Msg)
moduleCards model = List.map (moduleCard) (Data.modules model.activeModuleTab)

renderModulesAccordion : Model -> Html Msg
renderModulesAccordion model = Acc.config ModulesAccordion
                                |> Acc.withAnimation
                                |> Acc.cards
                                    (moduleCards model)
                                |> Acc.view model.moduleAccordionState

freddograph = [ C.chart
                    [ CA.height 100
                    , CA.width 500
                    , CA.padding { top = 10, bottom = 20, left = 50, right = 50 }
                    ]
                    [ C.xTicks [ CA.times Time.utc, CA.amount 8]
                    , C.xLabels [ CA.times Time.utc, CA.amount 8 ]
                    , C.series (.year >> yearToUnix)
                        -- [ C.stacked
                            [ C.interpolated .price [ CA.monotone ] [ CA.circle ]
                            , C.interpolated .inflated [ CA.monotone ] [ CA.square ]
                            ]
                        -- ]
                        Data.freddos
                    ]
                ]

view : Model -> Document Msg
view model = 
    {
        title = "james siq site",
        body = 
            [ CDN.stylesheet -- inline link to Bootstrap CSS
            , Styles.stylesheet -- inline link to global.css stylesheet
            , Utils.loadStylesheet "https://fonts.googleapis.com/icon?family=Material+Icons"
            , Grid.containerFluid []
                [ Grid.row []
                    [ Grid.col [Bootstrap.Grid.Col.xl12]
                        [ div [class "parallax", class "baba-img"] 
                            -- le header page
                            [ div 
                                -- attrs.
                                [class "jumbo-header", class "animate__animated", class "animate__fadeIn", class "animate__slower"]
                                -- content
                                [ h1 [class "my-4"] [text model.title]
                                , h2 [class "my-2"] [text "4th year computer science student (MSci)"]
                                , h3 [class "my-2"] [text "University of St Andrews"]
                                , a [class "btn", class "btn-primary", href "#hi"] [text "say hi"]
                                ]
                            ]
                            -- hi page
                            , div 
                                -- attrs.
                                [id "hi", class "px-4"]
                                -- content
                                [ h1 [style "font-size" "20rem"] [text "hi."]
                                , h2 [class "pb-4"] [text 
                                (toLower """
                                I'm a 4th year computer science student studying at the University of St Andrews. I really enjoy music and coding.
                                """)]
                                ]
                    
                        -- lil divider
                        , div [class "parallax", class "tree-img"] []
                        -- Modules taken
                        , div 
                            -- attrs.
                            [class "text-block", class "px-4", class "py-4"]
                            -- content
                            [ h1 [class "pb-4"] [text "Here's what I've been studying:"]
                            -- , h2 [class "my-2"] [text ""]
                            , renderModuleTabs model
                            -- , renderModulesContent model
                            , renderModulesAccordion model
                            ]
                        -- lil divider
                        , div [class "parallax", class "bilb-img"] []
                        -- work section
                        , div 
                            -- attrs.
                            [class "px-4", class "py-4"]
                            -- content
                            [ h1 [style "font-size" "10rem", class "py-4"] [text "work exp."]
                            , div [id "work-idr", class "pb-4"] [
                                -- idris
                                h2 [class "pb-2"] 
                                    [ text ("""Idris 2"""), br [] [],  small [] [text "09/2020 -> 01/2021"]]
                                , text 
                                """
                                I recently had the chance to work with Dr. Edwin Brady on his language
                                """
                                , a [href "https://www.idris-lang.org/", target "_blank"] [text "Idris 2"]
                                , text
                                """ as part of a research internship at the University of St Andrews. Idris 2 is a purely-functional programming language with dependent first-class types.
                                I wrote several runtime performance benchmark programs to aid our optimising of a newly-written reference-counting compiler,
                                written in C. I later compiled these into a benchmarking script which can be found in the main Idris 2
                                """
                                , a [href "https://github.com/idris-lang/Idris2/tree/main/benchmark", target "_blank"] [text "Github"]
                                , text """
                                repository.
                                """
                            ]
                            -- -- CMS
                            , div [id "work-shrowze", class "pb-4"] [
                                h2 [ class "pb-2" ] 
                                   [ text "Shrowze Ltd.", br [] [],  small [] [text "03/2020 -> 04/2020"]]
                                , text 
                                """
                                I developed the front-end for a content management system using Angular CLI and Bootstrap with both a public facing website and an
                                admin portal webapp to interact with the database. This was a unique commision for a client. I worked as part of a team of 4 developers
                                over the course of a month, testing and interfacing with API microservices written by the back-end half of the team using Node with Couchbase.
                                This gave me experience working on a real-world application, following a hybrid of agile and plan-driven development methods.
                                """
                            ]
                        ]
                        -- projects section
                        , div 
                            -- attrs.
                            [class "px-4", class "py-4"]
                            -- content
                            [ h1 [style "font-size" "10rem", class "py-4"] [text "projects."]
                            -- website
                            , div [id "proj-elm", class "pb-4"] [
                                h2 [ class "pb-2" ] 
                                   [ text "this!" ]
                                , text 
                                """
                                I wrote this site from scratch in
                                """
                                , a [href "https://elm-lang.org", target "_blank"] [text "Elm"]
                                , text 
                                """,
                                a purely functional language designed for web. This was my first time using the language. You can check out the source code on my
                                """
                                , a [href "https://github.com/jmd28/elm-site", target "_blank"] [text "Github"]
                                , text "."
                            ]
                            -- -- discord
                            , div [id "proj-disc", class "pb-4"] [
                                h2 [ class "pb-2" ] [ text "discord" ]
                                , text 
                                """
                                I have contributed to the development of multiple discord bots. A solo project I worked on
                                involved building a discord-based interface for the card game Uno, which uses pillow to
                                programatically generate images of the players' hands. I was also a part of the first-placing Honours team for
                                Hack the Bubble 2020, for which we created a discord.py bot inspired by the game Pictionary. The bot uses webscraping
                                and image processing techniques. This was subsequently featured on the discord server for Stacshack 2021
                                (and proved very popular!). 
                                You can view the source code
                                """
                                , a [href "https://github.com/jmd28/Ewan2.0", target "_blank"] [text "here"]
                                , text "."
                            ]
                            

                            ]
                        -- interests section
                        , div 
                            -- attrs.
                            [class "px-4", class "py-4"]
                            -- content
                            [ h1 [style "font-size" "10rem", class "py-4"] [text "interests."]
                            -- musc
                            , div [class "pb-4"] [
                                h2 [ class "pb-2" ] 
                                   [ text "music" ]
                                , text 
                                """
                                When I'm not busy in the computing labs I can usually be found with headphones on or a guitar in hand.
                                I often work on transcriptions, orchestrations and arrangements of music both by commission and for fun. I
                                play trumpet in the Big Band of the University of St Andrews
                                """
                                , a [href "https://www.facebook.com/BigBandoftheUniversityofStAndrews", target "_blank"]
                                 [text "(Big BUStA)"]
                                , text
                                """ and have appeared in numerous smaller bands, combos and orchestras over the years - which has taken me touring all across Europe.
                                During the lockdowns of 2020 and 2021, I worked on producing the online video performances for Big BUStA, which involved
                                mixing together individual mobile recordings of the players using a DAW (Reaper) and then editing together the video using Adobe Premiere Pro.
                                """
                            ]
                            -- -- walkies
                            , div [class "pb-4"] [
                                h2 [ class "pb-2" ] [ text "walking" ]
                                , text 
                                """
                                I live in the middle of the southern pennines which makes getting out onto the hills and moors super accessible.
                                I'm a big fan of nature and windy rainy days. You know where you are with a rainy day.
                                """
                            ]

                            -- freddo? lol
                            , h2 [] [text "look at this graph"]
                            , text "You can have five arbitrary points if you can guess what it shows"
                            , div [class "chart"] 
                                freddograph

                            ]
                        , div [class "parallax", class "baba-img"]
                            [ div 
                                [class "jumbo-header"]
                                [ h1 [class "my-4"] [text "links"]
                                -- email
                                , a [class "link-div", href "mailto:jmd28@st-andrews.ac.uk"] 
                                    [ span [class "material-icons", class "link-icon"] [text "mail"]
                                    , text "jmd28@st-andrews.ac.uk"
                                    ]
                                -- github
                                , a [class "link-div", href "https://github.com/jmd28", target "_blank"] 
                                    [ img [src "src/assets/icon/GitHub-64px.png", width 32, height 32, class "ml-1", class "mr-2"] [] 
                                    , text "GitHub"
                                    ]
                                ]
                            ]
                        
                        
                        ]
                    ]
                ]
            ]
    }