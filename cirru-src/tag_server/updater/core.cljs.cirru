
ns tag-server.updater.core $ :require
  [] tag-server.updater.state :as state
  [] tag-server.updater.user :as user
  [] tag-server.updater.tag :as tag
  [] tag-server.updater.query :as query
  [] tag-server.updater.topic :as topic
  [] tag-server.updater.message :as message

defn no-op-updater
  db op-data state-id op-id op-time
  , db

defn update-store
  db op op-data state-id op-id op-time
  .log js/console "|trying to update store"
  let
    (hint "|found no handler for:")
      update-method $ case op (:state/connect state/connect)
        :state/disconnect state/connect
        :state/route state/route
        :user/enter user/enter
        :user/rm-tag user/rm-tag
        :user/update user/update-profile
        :user/select-tag user/select-tag
        :user/logout user/logout
        :tag/submit tag/submit
        :query/tags query/tags
        :topic/create topic/create
        :message/create message/create
        do (println hint op)
          , no-op-updater

    update-method db op-data state-id op-id op-time
