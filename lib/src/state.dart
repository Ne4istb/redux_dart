library redux.state;

import 'package:collection/collection.dart';

/// The [State] object is Map based so all map methods are available.
/// It represents the state of the app or it's part.
class State extends DelegatingMap<String, dynamic> {
  /// Creates an instance of [State]
  State(Map<String, dynamic> base) : super(base);

  /// Creates a new [State] instance that contains all key-value pairs of [other]
  State.from(State other) : super(new Map<String, dynamic>.from(other));

  /// Returns an empty [State]
  static State get emptyState => new State(new Map<String, dynamic>());
}
