
ns tag-server.view.viewer $ :require
  [] tag-server.schema :as schema

defn extract-tree (state-id db)
  let
    (state $ get-in db ([] :states state-id))
      router $ :router state
      user-id $ :user-id state
      live-users $ ->>
        vals $ :states db
        filter $ fn (state)
          some? $ :user-id state
        map $ fn (state)
          get-in db $ [] :users (:user-id state)

    if (some? user-id)
      let
        (user $ get-in db ([] :users user-id))
          router $ get-in db
            [] :states state-id :router
          my-tags $ ->> (:tag-ids user)
            map $ fn (tag-id)
              get-in db $ [] :tags tag-id

          tags $ map val (:tags db)
          topics $ ->>
            vals $ :topics db
            filter $ fn (topic)
              if
                and
                  = :topics $ first router
                  some? $ get router 1
                contains? (:tag-ids topic)
                  get router 1
                some
                  fn (tag-id)
                    contains? (:tag-ids topic)
                      , tag-id

                  :tag-ids user

            map $ fn (topic)
              let
                (tags $ ->> (:tag-ids topic) (map $ fn (tag-id) (get-in db $ [] :tags tag-id)))

                -> topic (dissoc :messages)
                  assoc :tags tags

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

                        new-message $ assoc message :avatar
                          if
                            > (count avatar)
                              , 5
                            , avatar schema/default-avatar

                      [] (key entry)
                        , new-message

                  into $ {}

        assoc schema/store :state state :tags tags :my-tags my-tags :topics topics :user user :current-topic current-topic :live-users live-users

      assoc schema/store :state state :live-users live-users
