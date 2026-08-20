#include <cstdio>
#include <string>
#include <unordered_map>
#include <optional>
#include <stdexcept>

template <typename K, typename V>
class Cache {
private:
    struct Entry {
        V value;
        size_t access_count;
    };

    std::unordered_map<K, Entry> store_;
    size_t max_size_;

public:
    explicit Cache(size_t max_size) : max_size_(max_size) {}

    std::optional<V> get(const K& key) {
        auto it = store_.find(key);
        if (it == store_.end()) {
            return std::nullopt;
        }
        it->second.access_count++;
        return it->second.value;
    }

    void put(const K& key, const V& value) {
        if (store_.size() >= max_size_) {
            evict();
        }
        store_[key] = {value, 0};
    }

    bool contains(const K& key) const {
        return store_.find(key) != store_.end();
    }

    void remove(const K& key) {
        store_.erase(key);
    }

    void clear() {
        store_.clear();
    }

    size_t size() const {
        return store_.size();
    }

private:
    void evict() {
        if (store_.empty()) return;

        // Evict least-accessed entry
        auto min_it = store_.begin();
        for (auto it = store_.begin(); it != store_.end(); ++it) {
            if (it->second.access_count < min_it->second.access_count) {
                min_it = it;
            }
        }
        store_.erase(min_it);
    }
};

int main() {
    Cache<std::string, int> cache(100);

    cache.put("key1", 42);
    cache.put("key2", 100);

    if (auto val = cache.get("key1")) {
        std::printf("Found: %d\n", *val);
    }

    // TODO: Add thread safety
    // FIXME: UseLRU instead of LFU
    return 0;
}
