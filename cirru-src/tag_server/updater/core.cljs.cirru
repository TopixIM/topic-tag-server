
ns tag-server.updater.core $ :require
  [] tag-server.updater.state :as state

defn no-op-updater
  db op op-data state-id op-id op-time
  println "|updater not implemented yet" op
  , db

defn update-store
  db op op-data state-id op-id op-time
  let
    (update-method $ case op (:state/connect state/connect) (, no-op-updater))

    update-method db op op-data state-id op-id op-time
