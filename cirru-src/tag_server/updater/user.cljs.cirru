
ns tag-server.updater.user $ :require
  [] tag-server.schema :as schema
  [] tag-server.util.list :refer $ [] find-one

defn enter
  db op-data state-id op-id op-time
  let
    (username $ :name op-data)
      password $ :password op-data
      maybe-user $ find-one
        fn (user)
          = username $ :name user
        vals $ :users db

    if (some? maybe-user)
      if
        = password $ :password maybe-user
        assoc-in db
          [] :states state-id :user-id
          :id maybe-user
        do
          println "|wrong password" password maybe-user
          , db

      -> db
        assoc-in ([] :users op-id)
          assoc schema/user :id op-id :name username :password password
        assoc-in
          [] :states state-id :user-id
          , op-id

defn rm-tag
  db op-data state-id op-id op-time
  let
    (state $ get-in db ([] :states state-id))
      user-id $ :user-id state
      user $ get-in db ([] :users user-id)

    update-in db
      [] :users user-id :tag-ids
      fn (tag-ids)
        ->> tag-ids
          filter $ fn (tag-id)
            not= tag-id op-data
          into $ hash-set

defn select-tag
  db op-data state-id op-id op-time
  let
    (user-id $ get-in db ([] :states state-id :user-id))

    update-in db
      [] :users user-id :tag-ids
      fn (tag-ids)
        if
          < (count tag-ids)
            , 5
          into (hash-set)
            conj tag-ids op-data
          , tag-ids

defn update-profile
  db op-data state-id op-id op-time
  let
    (user-id $ get-in db ([] :states state-id :user-id))

    update-in db ([] :users user-id)
      fn (user)
        merge user op-data
