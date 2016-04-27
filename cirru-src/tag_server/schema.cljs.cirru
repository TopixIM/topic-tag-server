
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
  :name nil
  :tag-ids $ hash-set

def message $ {} (:id nil)
  :user-id nil
  :topic-id nil
  :text |

def store $ {} (:state nil)
  :tags $ {}
  :topics $ {}
  :user nil
