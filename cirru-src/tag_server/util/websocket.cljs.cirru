
ns tag-server.util.websocket
  :require-macros $ [] cljs.core.async.macros :refer ([] go)
  :require
    [] cljs.nodejs :as nodejs
    [] cljs.core.async :as a :refer $ [] >! <! chan
    [] cljs.reader :as reader

defonce receive-chan $ chan

defonce send-chan $ chan

defonce shortid $ js/require |shortid

defonce ws $ js/require |ws

defonce WebSocketServer $ .-Server ws

defonce socket-registry $ atom ({})

def wss $ new WebSocketServer (js-obj |port 4010)

.on wss |connection $ fn (socket)
  let
    (state-id $ .generate shortid)
      now $ new js/Date
    println "|new socket" state-id
    go $ >! receive-chan
      [] :state/connect nil state-id (.generate shortid)
        .valueOf now

    swap! socket-registry assoc state-id socket
    .on socket |message $ fn (rawData)
      let
        (now $ new js/Date)
          action $ reader/read-string rawData
          ([] op op-data) action

        go $ >! receive-chan
          [] op op-data state-id (.generate shortid)
            .valueOf now

    .on socket |close $ fn ()
      let
        (now $ new js/Date)
        swap! socket-registry dissoc state-id
        println "|socket close" state-id
        go $ >! receive-chan
          [] :state/disconnect state-id state-id (.generate shortid)
            .valueOf now

go $ loop ([])
  let
    (msg-pack $ <! send-chan)
      socket $ get @socket-registry (first msg-pack)

    -- println "|sending message pack:" $ pr-str msg-pack
    if (some? socket)
      .send socket $ pr-str (last msg-pack)
      println "|found no socket:" (first msg-pack)
        pr-str @socket-registry

    recur
