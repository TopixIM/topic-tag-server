
(ns tag-server.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs.nodejs :as nodejs]
            [tag-server.schema :as schema]
            [tag-server.updater.core :refer [update-store]]
            [tag-server.view.viewer :refer [extract-tree]]
            [cumulo-server.core :refer [setup-server! reload-renderer!]]
            [cljs.reader :as reader]))

(def fs (js/require "fs"))

(def db-filename "db.edn")

(defonce data-center
 (atom
   (if (.existsSync fs db-filename)
     (let [old-db (reader/read-string
                    (.readFileSync fs db-filename "utf8"))]
       (assoc old-db :states {}))
     schema/database)))

(defonce file-cache (atom @data-center))

(defn -main []
  (nodejs/enable-util-print!)
  (js/setInterval
    (fn []
      (if (not= @data-center @file-cache)
        (do
          (reset! file-cache @data-center)
          (.writeFileSync fs db-filename (pr-str @file-cache))
          (println "wrote to " db-filename))))
    20000)
  (setup-server!
    data-center
    update-store
    identity
    extract-tree
    {:port 4010})
  (println "server started"))

(set! *main-cli-fn* -main)

(defn on-jsload []
  (println "reload")
  (reload-renderer! @data-center update-store identity extract-tree))
