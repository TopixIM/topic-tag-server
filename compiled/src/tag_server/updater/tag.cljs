
(ns tag-server.updater.tag
  (:require [tag-server.schema :as schema]
            [tag-server.util.list :refer [find-one]]))

(defn submit [db op-data state-id op-id op-time]
  (let [maybe-tag (find-one
                    (fn [tag] (= op-data (:text tag)))
                    (vals (:tags db)))
        user-id (get-in db [:states state-id :user-id])]
    (if (some? maybe-tag)
      (update-in
        db
        [:users user-id :tag-ids]
        (fn [tag-ids]
          (if (< (count tag-ids) 5)
            (conj tag-ids (:id maybe-tag))
            tag-ids)))
      (let [new-tag (assoc schema/tag :id op-id :text op-data)]
        (-> db
         (assoc-in [:tags op-id] new-tag)
         (update-in
           [:users user-id :tag-ids]
           (fn [tag-ids]
             (if (< (count tag-ids) 5)
               (conj tag-ids op-id)
               tag-ids))))))))
