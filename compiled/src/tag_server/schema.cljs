
(ns tag-server.schema)

(def default-avatar "http://tp2.sinaimg.cn/1258256457/50/5616578718/1")

(def database {:tags {}, :states {}, :topics {}, :users {}})

(def state
 {:router [:home nil],
  :user-id nil,
  :notifications {},
  :id nil,
  :results {}})

(def user
 {:password "",
  :name nil,
  :id nil,
  :avatar default-avatar,
  :tag-ids (hash-set)})

(def tag {:id nil, :text nil})

(def topic {:time nil, :id nil, :tag-ids (hash-set), :text nil})

(def message
 {:time nil, :user-id nil, :id nil, :topic-id nil, :text ""})

(def store
 {:my-topics (list),
  :tags (list),
  :my-tags (list),
  :state nil,
  :topics (list),
  :live-users (list),
  :current-topic nil,
  :user nil,
  :buffer ""})

(def notification {:type :info, :id nil, :text ""})
