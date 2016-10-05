library redux.store;

import 'dart:async';

import 'action.dart';
import 'middleware.dart';
import 'reducer.dart';
import 'state.dart';

/// [Dispatcher] definition
typedef Future<dynamic> Dispatcher(Action action);

/// [Pipe] definition
typedef Dispatcher Pipe(Dispatcher next);

/// Redux store that holds the state tree.
/// The only way to change the data in the store is to call [dispatch] on it.
///
/// There should only be a single store in your app. To specify how different
/// parts of the state tree respond to [Action]s, you may combine several [Reducer]s
/// into a single [Reducer] function by using [combineReducers].
///
class Store extends Stream<State> {
  Reducer _reducer;
  State _currentState;
  Middleware _middleware;

  StreamController<State> _controller;

  /// Creates an instance of Redux [Store]
  ///
  /// [reducer] is a function that returns the next [State] tree, given
  /// the current [State] tree and the [Action] to handle.
  ///
  /// [initialState] is the initial [State].
  ///
  /// [middleware] is the store enhancer. You may optionally specify it
  /// to enhance the store with third-party capabilities such as middleware,
  /// time travel, persistence, etc. The only store enhancer that ships with Redux
  /// is [applyMiddleware].
  ///
  Store(Reducer reducer, {State initialState, Middleware middleware}) {
    if (initialState == null) initialState = State.emptyState;

    if (middleware != null) this._middleware = middleware;

    _reducer = reducer;
    _currentState = initialState;

    _controller = new StreamController.broadcast(); // ignore: always_specify_types
  }

  /// Reads the state tree managed by the store.
  ///
  /// Returns the current [State] tree of your application.
  ///
  State get state => _currentState;

  /// Dispatches an [Action]. It is the only way to trigger a [State] change.
  ///
  /// The [Reducer] function, used to create the store, will be called with the
  /// current state tree and the given [Action]. Its return value will
  /// be considered **next** state of the tree, and the change listeners
  /// will be notified.
  ///
  /// The base implementation only supports [Action] object.
  /// [Action] representing “what changed”. An action always has a `type` property.
  /// It is a good idea to use string constants for action types.
  ///
  /// Returns [Future<dynamic>] For convenience, the same action object you dispatched.
  ///
  /// Note that, if you use a custom middleware, it may wrap [dispatch] to
  /// return something else.
  ///
  Future<dynamic> dispatch(Action action) async {

    if (_middleware != null) {
      return _middleware(this)(dispatchWithoutMiddleware)(action);
    }

    return dispatchWithoutMiddleware(action);
  }
  
  Future<dynamic> dispatchWithoutMiddleware(Action action) async {
    _currentState = _reducer(_currentState, action);
    _controller.add(_currentState);
  
    return action;
  }
  
    /// Adds a change listener. It will be called any time an [Action] is dispatched,
  /// and some part of the state tree may potentially have changed. The callback
  /// will receive the current [State] as parameter
  ///
  /// You may call `dispatch()` from a change listener, with the following
  /// caveats:
  ///
  /// 1. The subscriptions are snapshotted just before every [dispatch] call.
  /// If you subscribe or unsubscribe while the listeners are being invoked, this
  /// will not have any effect on the [dispatch] that is currently in progress.
  /// However, the next [dispatch] call, whether nested or not, will use a more
  /// recent snapshot of the subscription list.
  ///
  /// 2. The listener should not expect to see all state changes, as the state
  /// might have been updated multiple times during a nested [dispatch] before
  /// the listener is called. It is, however, guaranteed that all subscribers
  /// registered before the [dispatch] started will be called with the latest
  /// state by the time it exits.
  ///
  @override
  StreamSubscription<State> listen(void onData(State event), {Function onError, void onDone(), bool cancelOnError}) {
    return _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  /// Closes store controller.
  ///
  /// After this action no changes will be available for subscription.
  ///
  void close() {
    _controller.close();
  }
}
