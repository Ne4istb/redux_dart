library redux.action;

/// The [Action] object representing “what changed”.
/// It always has mandatory [type] field and optional [data] field.
class Action {
  /// [Action] type
  String type;

  /// Contains data passed in [Action]
  Map<String, dynamic> data;

  /// Creates an instance of [Action]
  Action(this.type, [this.data = null]);
}
