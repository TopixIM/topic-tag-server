
ns tag-server.core
  :require-macros $ [] cljs.core.async.macros :refer ([] go)
  :require
    [] cljs.nodejs :as nodejs
    [] tag-server.schema :as schema
    [] tag-server.util.websocket :as ws-server
    [] tag-server.updater.core :refer $ [] update-store
    [] tag-server.view.viewer :refer $ [] extract-tree
    [] cljs.core.async :as a :refer $ [] >! <! chan
    [] differ.core :as differ
    [] cljs.reader :as reader

def fs $ js/require |fs

def db-filename |db.edn

defonce data-center $ atom
  if (.existsSync fs db-filename)
    let
      (old-db $ reader/read-string (.readFileSync fs db-filename |utf8))

      assoc old-db :states $ {}

    , schema/database

defonce file-cache $ atom @data-center

defonce client-caches $ atom ({})

go $ loop ([])
  let
    (msg $ <! ws-server/receive-chan)
      new-data $ apply update-store (cons @data-center msg)

    -- println "|received message" $ pr-str msg
    -- println |∆=db $ differ/diff @data-center new-data
    doseq
      [] state-entry $ :states new-data
      let
        (state-id $ first state-entry)
          new-store $ extract-tree state-id new-data
          old-store $ or (get @client-caches state-id)
            {}
          changes $ differ/diff old-store new-store

        if
          not= changes $ [] ({})
            {}
          do
            -- println |∆=client state-id changes
            >! ws-server/send-chan $ [] state-id changes
            swap! client-caches assoc state-id new-store

    reset! data-center new-data
    recur

defn rerender-view ()
  go $ doseq
    [] state-entry $ :states @data-center
    let
      (state-id $ first state-entry)
        new-store $ extract-tree state-id @data-center
        old-store $ or (get @client-caches state-id)
          {}
        changes $ differ/diff old-store new-store

      if
        not= changes $ [] ({})
          {}
        do
          println |∆=client state-id changes
          >! ws-server/send-chan $ [] state-id changes
          swap! client-caches assoc state-id new-store

defn -main ()
  nodejs/enable-util-print!
  js/setInterval
    fn ()
      if (not= @data-center @file-cache)
        do (reset! file-cache @data-center)
          .writeFileSync fs db-filename $ pr-str @file-cache
          println "|wrote to " db-filename

    , 20000

  println "|server started"

set! *main-cli-fn* -main

defn on-jsload ()
  println "|code updated..."
  rerender-view
