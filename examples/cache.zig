const std = @import("std");

/// A simple cache backed by a hash map.
pub fn Cache(comptime K: type, comptime V: type) type {
    return struct {
        const Self = @This();

        store: std.AutoHashMap(K, V),
        max_size: usize,

        pub fn init(allocator: std.mem.Allocator, max_size: usize) Self {
            return Self{
                .store = std.AutoHashMap(K, V).init(allocator),
                .max_size = max_size,
            };
        }

        pub fn deinit(self: *Self) void {
            self.store.deinit();
        }

        pub fn get(self: *const Self, key: K) ?V {
            return self.store.get(key);
        }

        pub fn put(self: *Self, key: K, value: V) !void {
            if (self.store.count() >= self.max_size) {
                var it = self.store.iterator();
                if (it.next()) |entry| {
                    _ = self.store.remove(entry.key_ptr.*);
                }
            }
            try self.store.put(key, value);
        }

        pub fn contains(self: *const Self, key: K) bool {
            return self.store.contains(key);
        }

        pub fn clear(self: *Self) void {
            self.store.clearRetainingCapacity();
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var cache = Cache([]const u8, i64).init(allocator, 100);
    defer cache.deinit();

    try cache.put("key1", 42);
    try cache.put("key2", 100);

    if (cache.get("key1")) |value| {
        std.debug.print("Found: {d}\n", .{value});
    }

    // TODO: Add TTL support
    // FIXME: Thread safety
}
