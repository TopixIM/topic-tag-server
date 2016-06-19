
(ns tag-server.updater.state
  (:require [tag-server.schema :as schema]))

(defn connect [db op-data state-id op-id op-time]
  (assoc-in db [:states state-id] (assoc schema/state :id state-id)))

(defn disconnect [db op-data state-id op-id op-time]
  (update db :states (fn [states] (dissoc states state-id))))

(defn route [db op-data state-id op-id op-time]
  (-> db
   (assoc-in
     [:states state-id :router]
     (if (keyword? op-data) [op-data nil] op-data))
   (assoc-in [:states state-id :buffer] "")))

(defn buffer [db op-data state-id op-id op-time]
  (assoc-in db [:states state-id :buffer] op-data))
