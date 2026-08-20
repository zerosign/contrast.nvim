import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Thread-safe in-memory cache with TTL support.
 */
public class Cache<K, V> {

    private final Map<K, Entry<V>> store;
    private final int maxSize;
    private final long defaultTtlMs;

    private static class Entry<V> {
        final V value;
        final long expiresAt;

        Entry(V value, long ttlMs) {
            this.value = value;
            this.expiresAt = System.currentTimeMillis() + ttlMs;
        }

        boolean isExpired() {
            return System.currentTimeMillis() > expiresAt;
        }
    }

    public Cache(int maxSize, long defaultTtlMs) {
        this.maxSize = maxSize;
        this.defaultTtlMs = defaultTtlMs;
        this.store = new ConcurrentHashMap<>();
    }

    public Optional<V> get(K key) {
        Entry<V> entry = store.get(key);
        if (entry == null || entry.isExpired()) {
            store.remove(key);
            return Optional.empty();
        }
        return Optional.of(entry.value);
    }

    public void put(K key, V value) {
        if (store.size() >= maxSize) {
            evictExpired();
            if (store.size() >= maxSize) {
                store.remove(store.keySet().iterator().next());
            }
        }
        store.put(key, new Entry<>(value, defaultTtlMs));
    }

    public void remove(K key) {
        store.remove(key);
    }

    public void clear() {
        store.clear();
    }

    private void evictExpired() {
        store.entrySet().removeIf(e -> e.getValue().isExpired());
    }

    public static void main(String[] args) {
        Cache<String, Integer> cache = new Cache<>(100, 60_000);
        cache.put("key1", 42);
        cache.put("key2", 100);

        cache.get("key1").ifPresent(v ->
            System.out.printf("Found: %d%n", v)
        );

        // TODO: Add stats tracking
        // FIXME: WeakReference keys for large caches
    }
}
