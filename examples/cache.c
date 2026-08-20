#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_KEY_LEN 64
#define MAX_CACHE_SIZE 100

typedef struct Entry {
    char key[MAX_KEY_LEN];
    int value;
    struct Entry *next;
} Entry;

typedef struct {
    Entry *head;
    Entry *tail;
    int size;
    int max_size;
} Cache;

/* Create a new cache */
Cache *cache_create(int max_size) {
    Cache *cache = malloc(sizeof(Cache));
    if (!cache) return NULL;
    cache->head = NULL;
    cache->tail = NULL;
    cache->size = 0;
    cache->max_size = max_size;
    return cache;
}

/* Get a value by key. Returns -1 if not found. */
int cache_get(Cache *cache, const char *key) {
    Entry *current = cache->head;
    while (current) {
        if (strcmp(current->key, key) == 0) {
            return current->value;
        }
        current = current->next;
    }
    return -1;
}

/* Insert or update a key-value pair */
void cache_put(Cache *cache, const char *key, int value) {
    /* Check if key already exists */
    Entry *current = cache->head;
    while (current) {
        if (strcmp(current->key, key) == 0) {
            current->value = value;
            return;
        }
        current = current->next;
    }

    /* Evict oldest if at capacity */
    if (cache->size >= cache->max_size && cache->head) {
        Entry *old = cache->head;
        cache->head = old->next;
        if (!cache->head) cache->tail = NULL;
        free(old);
        cache->size--;
    }

    /* Add new entry at tail */
    Entry *entry = malloc(sizeof(Entry));
    if (!entry) return;
    strncpy(entry->key, key, MAX_KEY_LEN - 1);
    entry->key[MAX_KEY_LEN - 1] = '\0';
    entry->value = value;
    entry->next = NULL;

    if (cache->tail) {
        cache->tail->next = entry;
    } else {
        cache->head = entry;
    }
    cache->tail = entry;
    cache->size++;
}

/* Free all cache memory */
void cache_destroy(Cache *cache) {
    Entry *current = cache->head;
    while (current) {
        Entry *next = current->next;
        free(current);
        current = next;
    }
    free(cache);
}

int main(void) {
    Cache *cache = cache_create(MAX_CACHE_SIZE);
    if (!cache) return 1;

    cache_put(cache, "key1", 42);
    cache_put(cache, "key2", 100);

    int val = cache_get(cache, "key1");
    if (val != -1) {
        printf("Found: %d\n", val);
    }

    cache_destroy(cache);

    /* TODO: Add hash-based lookup */
    /* FIXME: Handle key collisions */
    return 0;
}
