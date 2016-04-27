
ns tag-server.updater.user $ :require
  [] tag-server.schema :as schema

defn enter
  db op-data state-id op-id op-time
  let
    (username $ :name op-data)
      password $ :password op-data
      maybe-user $ some
        fn (entry)
          = username $ :name (val entry)

        :users db

    if (some? maybe-user)
      if
        = password $ :password maybe-user
        assoc-in db
          [] :states state-id :user-id
          :id maybe-user
        do db

      -> db
        assoc-in ([] :users op-id)
          assoc schema/user :id op-id :name username :password password
        assoc-in
          [] :states state-id :user-id
          , op-id
