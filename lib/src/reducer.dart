library redux.reducer;

import 'action.dart';
import 'state.dart';

/// This is a [Reducer] definition, a pure function with (State state, Action action) => State state signature.
/// It describes how an [Action] transforms the [State] into the next [State].
typedef State Reducer(State state, Action action);

/// Turns a [List] of [Reducer] functions, into a single [Reducer] function.
/// It will call every child reducer, and gather their results
/// into a single [State] object, whose keys correspond to the keys of the passed
/// [Reducer] functions.
Reducer combineReducers(List<Reducer> reducers) => (State state, Action action) =>
    reducers.fold(state, (State currentState, Reducer reducer) => reducer(currentState, action));
