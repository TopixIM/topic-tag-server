
ns tag-server.updater.state $ :require
  [] tag-server.schema :as schema

defn connect
  db op op-data state-id op-id op-time
  assoc-in db $ [] :states state-id
    assoc schema/state :id state-id
