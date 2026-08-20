package main

import (
	"fmt"
	"sync"
)

// Cache is a thread-safe LRU cache
type Cache[K comparable, V any] struct {
	mu      sync.RWMutex
	data    map[K]V
	order   []K
	maxSize int
}

// NewCache creates a new cache with the given maximum size
func NewCache[K comparable, V any](maxSize int) *Cache[K, V] {
	return &Cache[K, V]{
		data:    make(map[K]V),
		order:   make([]K, 0),
		maxSize: maxSize,
	}
}

// Get retrieves a value from the cache
func (c *Cache[K, V]) Get(key K) (V, bool) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	val, ok := c.data[key]
	return val, ok
}

// Set adds a value to the cache
func (c *Cache[K, V]) Set(key K, value V) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if len(c.data) >= c.maxSize {
		oldest := c.order[0]
		c.order = c.order[1:]
		delete(c.data, oldest)
	}

	c.data[key] = value
	c.order = append(c.order, key)
}

// Clear removes all entries from the cache
func (c *Cache[K, V]) Clear() {
	c.mu.Lock()
	defer c.mu.Unlock()

	c.data = make(map[K]V)
	c.order = c.order[:0]
}

func main() {
	cache := NewCache[string, int](100)

	cache.Set("one", 1)
	cache.Set("two", 2)
	cache.Set("three", 3)

	if val, ok := cache.Get("one"); ok {
		fmt.Printf("Found: %d\n", val)
	}

	// TODO: Add expiration support
	// FIXME: Handle concurrent writes better
}
