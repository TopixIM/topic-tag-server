
(ns tag-server.updater.query
  (:require [tag-server.util.list :refer [filter-n]]))

(defn tags [db op-data state-id op-id op-time]
  (let [some-results (if (> (count op-data) 0)
                       (filter-n
                         10
                         (fn [tag]
                           (>= (.indexOf (:text tag) op-data) 0))
                         (vals (:tags db)))
                       (list))]
    (assoc-in db [:states state-id :results :tags] some-results)))
