#redux

Redux is a predictable state container inspired by [Redux JavaScript library](http://redux.js.org).  
It helps you write applications that behave consistently, run in different environments (client, server, and native), and are easy to test.

Dart package info is here: https://pub.dartlang.org/packages/redux

> More details about Redux in[the original repository](http://redux.js.org)

>**Learn Redux from its creator:  
>[Getting Started with Redux](https://egghead.io/series/getting-started-with-redux) (30 free videos)**

## Quick start

The whole state of your app is stored in an object tree inside a single *Store*, which is Stream based.  
The only way to change the state tree is to emit an *Action*, an object describing what happened.  
To specify how the actions transform the state tree, you write pure *Reducers*.

That's it!

```dart
import 'package:redux/redux.dart';

/**
 * This is a Reducer, a pure function with (State state, Action action) => State state signature.
 * It describes how an action transforms the state into the next state.
 *
 * The State object is Map based so all map methods are available. The Action object always has mandatory type field 
 * and optional data. The only important part is that you should not mutate the state object, 
 * but return a new object if the state changes.
 *
 * In this example, we use a `switch` statement and strings, but you can use a helper that
 * follows a different convention (such as function maps) if it makes sense for your
 * project.
 */
 
State counter(State state, Action action) {
  switch (action.type) {
      case 'INCREMENT':
        return new State.from(state)
          ..['value'] = state['value'] + 1;
      case 'DECREMENT':
        return new State.from(state)
          ..['value'] = state['value'] - 1;
      default:
        return state;
  }
}

// Create a Redux store holding the state of your app.
// Its API is { subscribe, dispatch, getState }.

var store = new Store(counter);


// You can use listen() to update the UI in response to state changes.

store.listen((state) => print(state));


// The only way to mutate the internal state is to dispatch an action.
// The actions can be serialized, logged or stored and later replayed.

store.dispatch(new Action('INCREMENT'));
// {'value': 1}
store.dispatch(new Action('INCREMENT'));
// {'value': 2}
store.dispatch(new Action('DECREMENT'));
// {'value': 1}
```

Instead of mutating the state directly, you specify the mutations you want to happen with *Action objects*. Then you 
write a special *Reducer function* to decide how every *Action* transforms the entire application's 
*State*.

If you're coming from Flux, there is a single important difference you need to understand. Redux doesn't have a 
Dispatcher or support many stores. Instead, there is just a single store with a single root reducing function. As your app grows, instead of adding stores, you split the root reducer into smaller reducers independently operating on the different parts of the state tree. It is composed out of many small components.

This architecture might seem like an overkill for a counter app, but the beauty of this pattern is how well it scales to large and complex apps. It also enables very powerful developer tools, because it is possible to trace every mutation to the action that caused it. You can record user sessions and reproduce them just by replaying every action.

## Examples

The basic example is in [example file](https://github.com/Ne4istb/pocket_client/blob/master/example/redux_dart.dart)

## Features and bugs

Please fill feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Ne4istb/redux_dart/issues

## License

redux is distributed under the [MIT license](https://github.com/Ne4istb/redux_dart/blob/master/LICENSE).