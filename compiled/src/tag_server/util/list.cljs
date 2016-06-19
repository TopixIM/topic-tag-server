
(ns tag-server.util.list)

(defn find-one [method xs]
  (if (= 0 (count xs))
    nil
    (let [cursor (first xs)]
      (if (method cursor) cursor (recur method (rest xs))))))

(defn filter-n
  ([n method xs] (filter-n (list) n method xs))
  ([acc n method xs]
    (if (= 0 (count xs))
      acc
      (let [cursor (first xs)
            next-acc (if (method cursor) (cons cursor acc) acc)]
        (if (>= (count next-acc) n)
          next-acc
          (recur next-acc n method (rest xs)))))))
