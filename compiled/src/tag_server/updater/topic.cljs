
(ns tag-server.updater.topic
  (:require [tag-server.schema :as schema]))

(defn create [db op-data state-id op-id op-time]
  (let [new-topic (-> schema/topic
                   (assoc :id op-id :time op-time)
                   (merge op-data))]
    (-> db
     (assoc-in [:topics op-id] new-topic)
     (assoc-in [:states state-id :router] [:topics nil]))))

(defn open-editor [db op-data state-id op-id op-time]
  (let [topic (get-in db [:topics op-data])
        tags (map
               (fn [tag-id] (get-in db [:tags tag-id]))
               (:tag-ids topic))
        topic-data (assoc topic :tags tags)]
    (-> db
     (assoc-in [:states state-id :router] [:topic-editor topic-data]))))

(defn update-topic [db op-data state-id op-id op-time]
  (let [[topic-id topic-changes] op-data]
    (-> db
     (update-in
       [:topics topic-id]
       (fn [topic] (merge topic topic-changes)))
     (assoc-in [:states state-id :router] [:chat-room topic-id]))))
