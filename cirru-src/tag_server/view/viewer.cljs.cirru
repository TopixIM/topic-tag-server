
ns tag-server.view.viewer $ :require
  [] tag-server.schema :as schema

defn extract-tree (state-id db)
  let
    (state $ get-in db ([] :states state-id))
      router $ :router state
      user-id $ :user-id state

    if (some? user-id)
      let
        (user $ get-in db ([] :users user-id))
          tags $ ->> (:tag-ids user)
            map $ fn (tag-id)
              get-in db $ [] :tags tag-id

          topics $ map
            fn (entry)
              dissoc (val entry)
                , :messages

            :topics db

          topic-id $ if
            = :chat-room $ first router
            get router 1
            , nil
          current-topic $ if (nil? topic-id)
            , nil
            update
              get-in db $ [] :topics topic-id
              , :messages
              fn (messages)
                ->> messages
                  map $ fn (entry)
                    let
                      (message $ val entry)
                        avatar $ get-in db
                          [] :users (:user-id message)
                            , :avatar

                        new-message $ assoc message :avatar avatar

                      [] (key entry)
                        , new-message

                  into $ {}

        assoc schema/store :state state :tags tags :topics topics :user user :current-topic current-topic

      assoc schema/store :state state
