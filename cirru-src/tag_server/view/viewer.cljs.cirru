
ns tag-server.view.viewer $ :require
  [] tag-server.schema :as schema

defn extract-tree (state-id db)
  let
    (state $ get-in db ([] :states state-id))
      user-id $ :user-id state

    if (some? user-id)
      let
        (user $ get-in db ([] :users user-id))
          tags $ ->> (:tag-ids user)
            map $ fn (tag-id)
              get-in db $ [] :tags tag-id

          topics $ []

        assoc schema/store :state state :tags tags :topics topics :user user

      assoc schema/store :state state
