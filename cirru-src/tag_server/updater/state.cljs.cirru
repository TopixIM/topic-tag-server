
ns tag-server.updater.state $ :require
  [] tag-server.schema :as schema

defn connect
  db op-data state-id op-id op-time
  assoc-in db ([] :states state-id)
    assoc schema/state :id state-id

defn disconnect
  db op-data state-id op-id op-time
  update db :states $ fn (states)
    dissoc states state-id