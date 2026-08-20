package examples

import scala.collection.mutable

/** Thread-safe in-memory cache with configurable eviction. */
class Cache[K, V](maxSize: Int) {

  private val store = mutable.LinkedHashMap.empty[K, V]
  private val lock = new Object

  /** Get a value by key. Returns None if missing or evicted. */
  def get(key: K): Option[V] = lock.synchronized {
    store.get(key).filter { _ =>
      // Move to end (most recently used)
      store.remove(key)
      store.put(key, _)
      true
    }
  }

  /** Insert a key-value pair. Evicts oldest entry if at capacity. */
  def put(key: K, value: V): Unit = lock.synchronized {
    if (store.size >= maxSize && !store.contains(key)) {
      store.remove(store.head._1)
    }
    store.put(key, value)
  }

  /** Remove a specific key. */
  def remove(key: K): Unit = lock.synchronized {
    store.remove(key)
  }

  /** Clear all entries. */
  def clear(): Unit = lock.synchronized {
    store.clear()
  }

  /** Current number of entries. */
  def size: Int = lock.synchronized store.size
}

object Cache {
  def apply[K, V](maxSize: Int): Cache[K, V] = new Cache[K, V](maxSize)
}

object Main extends App {
  val cache = Cache[String, Int](100)
  cache.put("one", 1)
  cache.put("two", 2)
  cache.put("three", 3)

  cache.get("one").foreach(v =>
    println(s"Found: $v")
  )

  // TODO: Add async support
  // FIXME: Add serialization
}
