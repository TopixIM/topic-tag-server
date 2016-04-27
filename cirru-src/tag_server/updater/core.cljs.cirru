
ns tag-server.updater.core $ :require
  [] tag-server.updater.state :as state
  [] tag-server.updater.user :as user

defn no-op-updater
  db op-data state-id op-id op-time
  , db

defn update-store
  db op op-data state-id op-id op-time
  .log js/console "|trying to update store"
  let
    (update-method $ case op (:state/connect state/connect) (:state/disconnect state/connect) (:user/enter user/enter) (do (println "|found no handler for:" op) (, no-op-updater)))

    update-method db op-data state-id op-id op-time
