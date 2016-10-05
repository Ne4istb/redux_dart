library redux.middleware;

import 'dart:mirrors';
import 'package:fp/fp.dart' show compose;

import 'store.dart';

/// This is a [Middleware] definition.
/// It wraps [Store.dispatch] with extra functionality.
typedef Pipe Middleware(Store store);

/// Creates a store enhancer that applies [Middleware] to the dispatch method
/// of the Redux [Store]. This is handy for a variety of tasks, such as expressing
/// asynchronous actions in a concise manner, or logging every action payload.
///
/// Because middleware is potentially asynchronous, this should be the first
/// store enhancer in the composition chain.
///
/// Note that each [Middleware] will be given the [Store.dispatch] functions
/// as named arguments.
///
/// Takes a [List] of [Middleware]. The middleware chain to be applied.
/// Returns [Middleware] A store enhancer applying the middleware.
///
Middleware applyMiddleware(List<Middleware> middlewares) {
  return (Store store) => (Dispatcher next) {
        List<Pipe> chain = middlewares.map((Middleware middleware) => middleware(store)).toList();
        return compose(chain)(store.dispatchWithoutMiddleware) as Dispatcher; // ignore: avoid_as
      };
}
