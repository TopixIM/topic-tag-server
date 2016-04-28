
ns tag-server.updater.topic $ :require
  [] tag-server.schema :as schema

defn create
  db op-data state-id op-id op-time
  let
    (new-topic $ -> schema/topic (assoc :id op-id :time op-time) (merge op-data))

    assoc-in db ([] :topics op-id)
      , new-topic
