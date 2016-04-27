
ns tag-server.view.viewer $ :require
  [] tag-server.schema :as schema

defn extract-tree (state-id store)
  let
    (state $ get-in store ([] :states state-id)) (tags $ [])
      topics $ []

    assoc schema/store :state state :tags tags :topics topics
