
(ns tag-server.updater.message
  (:require [tag-server.schema :as schema]))

(defn create [db op-data state-id op-id op-time]
  (let [router (get-in db [:states state-id :router])
        topic-id (get router 1)
        user-id (get-in db [:states state-id :user-id])
        new-message (assoc
                      schema/message
                      :id
                      op-id
                      :text
                      op-data
                      :topic-id
                      topic-id
                      :time
                      op-time
                      :user-id
                      user-id)]
    (-> db
     (assoc-in [:topics topic-id :messages op-id] new-message)
     (assoc-in [:states state-id :buffer] ""))))
