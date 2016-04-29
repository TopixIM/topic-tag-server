
ns tag-server.schema

def default-avatar |http://tp2.sinaimg.cn/1258256457/50/5616578718/1

def database $ {} (:users $ {})
  :states $ {}
  :tags $ {}
  :topics $ {}

def state $ {} (:id nil)
  :user-id nil
  :notifications $ {}
  :router $ [] :home nil
  :results $ {}

def user $ {} (:id nil)
  :name nil
  :tag-ids $ hash-set
  :avatar default-avatar
  :password |

def tag $ {} (:id nil)
  :text nil

def topic $ {} (:id nil)
  :text nil
  :tag-ids $ hash-set
  :time nil

def message $ {} (:id nil)
  :user-id nil
  :topic-id nil
  :time nil
  :text |

def store $ {} (:state nil)
  :my-tags $ list
  :tags $ list
  :topics $ list
  :user nil
  :current-topic nil
  :live-users $ list
