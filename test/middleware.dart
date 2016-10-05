import 'package:test/test.dart';

import 'package:redux/redux.dart';
import 'helpers.dart';

class ApplyMiddlewareTests {
  static void run() {
    group('Redux apply middleware', () {
      test('Should apply composed middleware', () async {
        Middleware middleware1 = (store) => (next) => (action) {
              action.data['text'] += ' + "String from 1st middleware"';

              return next(action);
            };

        Middleware middleware2 = (store) => (next) => (action) {
              action.data['text'] += ' + "String from 2nd middleware"';

              return next(action);
            };

        Store store =
            new Store(testReducer, initialState: testState, middleware: applyMiddleware([middleware1, middleware2]));

        await await store.dispatch(addRecordAction('"String from outside"'));

        expect(store.state, {
          'initialized': true,
          'meaningOfLife': 42,
          'list': [
            {'message': '"String from outside" + "String from 1st middleware" + "String from 2nd middleware"'},
          ]
        });
      });
      
      test('Should be abble to dispatch the same action without loosing composed middleware chain', () async {
        
        Middleware middleware1 = (store) => (next) => (action) {
          action.data['text'] += 'm1->';

          return next(action);
        };

        var firstTime = true;
        Middleware middleware2 = (store) => (next) => (action) {
          action.data['text'] += 'm2->';
              
          if (firstTime){
            firstTime = false;
            store.dispatch(action);
          }

          return next(action);
        };

        Store store =
            new Store(testReducer, initialState: testState, middleware: applyMiddleware([middleware1, middleware2]));

        await store.dispatch(addRecordAction('Init ->'));

        expect(store.state, {
          'initialized': true,
          'meaningOfLife': 42,
          'list': [
            {'message': 'Init ->m1->m2->m1->m2->'}
          ]
        });
      });
      
      test('Should be abble to invoke next twice action without loosing composed middleware chain', () async {
        
        Middleware middleware1 = (store) => (next) => (action) {
          action.data['text'] += 'm1->';

          return next(action);
        };

        var firstTime = true;
        Middleware middleware2 = (store) => (next) => (action) {
          action.data['text'] += 'm2->';
              
          if (firstTime){
            firstTime = false;
            next(action);
          }

          return next(action);
        };

        Store store =
            new Store(testReducer, initialState: testState, middleware: applyMiddleware([middleware1, middleware2]));

        await store.dispatch(addRecordAction('Init ->'));

        expect(store.state, {
          'initialized': true,
          'meaningOfLife': 42,
          'list': [
            {'message': 'Init ->m1->m2->'},
            {'message': 'Init ->m1->m2->'}
          ]
        });
      });
    });
  }
}

void main() {
  ApplyMiddlewareTests.run();
}
