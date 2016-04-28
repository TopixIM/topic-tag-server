
ns tag-server.schema

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
  :avatar nil
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
  :tags $ list
  :topics $ list
  :user nil
  :current-topic nil
