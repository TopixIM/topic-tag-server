
ns topic-tag-server.core

defn -main ()
  enable-console-print!
  println |loaded

set! *main-cli-fn* -main

defn on-jsload ()
  println |reload!
