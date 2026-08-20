use std::collections::HashMap;

/// A simple cache implementation
pub struct Cache<K, V> {
    data: HashMap<K, V>,
    max_size: usize,
}

impl<K, V> Cache<K, V>
where
    K: Eq + std::hash::Hash,
{
    /// Create a new cache with the given maximum size
    pub fn new(max_size: usize) -> Self {
        Self {
            data: HashMap::new(),
            max_size,
        }
    }

    /// Insert a key-value pair into the cache
    pub fn insert(&mut self, key: K, value: V) -> Option<V> {
        if self.data.len() >= self.max_size {
            self.data
                .keys()
                .next()
                .cloned()
                .and_then(|k| self.data.remove(&k));
        }
        self.data.insert(key, value)
    }

    /// Get a value from the cache
    pub fn get(&self, key: &K) -> Option<&V> {
        self.data.get(key)
    }

    /// Check if the cache contains a key
    pub fn contains(&self, key: &K) -> bool {
        self.data.contains_key(key)
    }

    /// Clear the cache
    pub fn clear(&mut self) {
        self.data.clear();
    }
}

fn main() {
    let mut cache = Cache::new(100);
    cache.insert("key1", 42);
    cache.insert("key2", 100);

    if let Some(value) = cache.get(&"key1") {
        println!("Found: {}", value);
    }

    // TODO: Add more sophisticated eviction policy
    // FIXME: Handle thread safety
    todo!()
}
