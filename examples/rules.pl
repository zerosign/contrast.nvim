% A simple Prolog implementation of a knowledge base
% for reasoning about dependencies and ordering.

:- module(cache, [
    cache_get/2,
    cache_put/3,
    cache_init/1,
    cache_clear/1,
    depends/2,
    topological_sort/2
]).

:- dynamic cached/3.

%% cache_init(+MaxSize)
%  Initialize an empty cache with a maximum size.
cache_init(MaxSize) :-
    assert(max_cache_size(MaxSize)).

%% cache_put(+Key, +Value, +TTL)
%  Store a key-value pair in the cache with TTL in seconds.
cache_put(Key, Value, TTL) :-
    get_time(Now),
    Expires is Now + TTL,
    retractall(cached(Key, _, _)),
    assert(cached(Key, Value, Expires)).

%% cache_get(+Key, -Value)
%  Retrieve a value if it exists and hasn't expired.
cache_get(Key, Value) :-
    cached(Key, Value, Expires),
    get_time(Now),
    Now < Expires.

%% cache_clear(+Key)
%  Remove a specific key from the cache.
cache_clear(Key) :-
    retractall(cached(Key, _, _)).

%% depends(+A, +B)
%  A depends on B (B must be processed before A).
:- dynamic depends/2.

depends(module_a, module_b).
depends(module_b, module_c).
depends(module_a, module_c).
depends(module_d, module_a).

%% topological_sort(-Sorted)
%  Topological sort of modules based on dependencies.
topological_sort(Sorted) :-
    findall(X, depends(X, _), AllModules),
    list_to_set(AllModules, Unique),
    topo_sort(Unique, [], Sorted).

topo_sort([], Acc, Sorted) :-
    reverse(Acc, Sorted).
topo_sort([H|T], Acc, Sorted) :-
    (   depends(H, _),
        \+ memberchk(H, Acc)
    ->  topo_sort(T, [H|Acc], Sorted)
    ;   topo_sort(T, Acc, Sorted)
    ).

%% Example usage
:- initialization(
    cache_init(1000),
    now
).
