
(set-env!
 :dependencies '[[org.clojure/clojurescript "1.9.76"      :scope "test"]
                 [org.clojure/clojure       "1.8.0"       :scope "test"]
                 [adzerk/boot-cljs          "1.7.228-1"   :scope "test"]
                 [figwheel-sidecar          "0.5.4-3"     :scope "test"]
                 [cirru/boot-cirru-sepal    "0.1.8"       :scope "test"]
                 [com.cemerick/piggieback   "0.2.1"       :scope "test"]
                 [org.clojure/tools.nrepl   "0.2.10"      :scope "test"]
                 [ajchemist/boot-figwheel   "0.5.2-1"     :scope "test"]
                 [adzerk/boot-test          "1.1.1"       :scope "test"]
                 [cumulo/server             "0.1.0"]])

(require '[adzerk.boot-cljs :refer [cljs]]
         '[adzerk.boot-test   :refer :all]
         '[cirru-sepal.core :refer [transform-cirru]]
         '[boot-figwheel])

(refer 'boot-figwheel :rename '{cljs-repl fw-cljs-repl}) ; avoid some symbols

(def +version+ "0.1.0")

(task-options!
  pom {:project     'mvc-works/boot-workflow
       :version     +version+
       :description "Workflow"
       :url         "https://github.com/mvc-works/boot-workflow"
       :scm         {:url "https://github.com/mvc-works/boot-workflow"}
       :license     {"MIT" "http://opensource.org/licenses/mit-license.php"}})

(deftask compile-cirru []
  (set-env!
    :source-paths #{"cirru/"})
  (comp
    (transform-cirru)
    (target :dir #{"compiled/"})))

(task-options!
 figwheel {:build-ids  ["dev"]
           :all-builds [{:id "dev"
                         :compiler {:main 'tag-server.core
                                    :target :nodejs
                                    :output-to "app.js"}
                         :figwheel {:build-id  "dev"
                                    :on-jsload 'tag-server.core/on-jsload
                                    :autoload true
                                    :heads-up-display true}}]
           :figwheel-options {:repl true
                              :open-file-command "e"}})

(deftask watch-cirru []
  (set-env!
    :source-paths #{"cirru/"})
  (comp
    (watch)
    (transform-cirru)
    (target :dir #{"compiled/"})))

(deftask dev []
  (set-env!
    :source-paths #(into % ["compiled/src/"]))
  (comp
    (repl)
    (figwheel)
    (target)))

(deftask build-simple []
  (set-env!
    :source-paths #{"cirru/src"})
  (comp
    (transform-cirru)
    (cljs :optimizations :simple :compiler-options {:target :nodejs})
    (target)))

(deftask build-advanced []
  (set-env!
    :source-paths #{"cirru/src"})
  (comp
    (transform-cirru)
    (cljs :optimizations :advanced :compiler-options {:target :nodejs})
    (target)))

(deftask rsync []
  (with-pre-wrap fileset
    (sh "rsync" "-r" "target/" "tiye:repo/mvc-works/boot-workflow" "--exclude" "main.out" "--delete")
    fileset))

(deftask send-tiye []
  (comp
    (build-simple)
    (rsync)))

(deftask build []
  (set-env!
    :source-paths #{"cirru/src"})
  (comp
    (transform-cirru)
    (pom)
    (jar)
    (install)
    (target)))

(deftask deploy []
  (set-env!
    :repositories #(conj % ["clojars" {:url "https://clojars.org/repo/"}]))
  (comp
    (build)
    (push :repo "clojars" :gpg-sign (not (.endsWith +version+ "-SNAPSHOT")))))

(deftask watch-test []
  (set-env!
    :source-paths #{"cirru/src" "cirru/test"})
  (comp
    (watch)
    (transform-cirru)
    (test :namespaces '#{boot-workflow.test})))
