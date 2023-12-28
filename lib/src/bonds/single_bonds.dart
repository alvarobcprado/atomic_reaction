import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/utils/typedefs.dart';
import 'package:flutter/cupertino.dart';

/// {@template state_bond}
/// A [StateBond] is a widget that listens to changes on an [StateAtom] and
/// rebuilds whenever the [StateAtom] changes.
/// {@endtemplate}
class StateBond<S> extends StatelessWidget {
  /// {@macro state_bond}
  const StateBond({
    required this.atom,
    required this.builder,
    super.key,
  });

  /// The [StateAtom] to listen to.
  final StateAtom<S> atom;

  /// The [BondBuilder] to use to build the widget.
  final BondBuilder<S> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: atom.stream,
      initialData: atom.value,
      builder: (context, snapshot) {
        final currentValue = snapshot.data;

        return builder(context, currentValue as S);
      },
    );
  }
}

/// {@template action_bond}
/// An [ActionBond] is a widget that listens to changes on an [ActionAtom] and
/// calls a callback whenever the [ActionAtom] changes.
/// {@endtemplate}
class ActionBond<A> extends StatefulWidget {
  /// {@macro action_bond}
  const ActionBond({
    required this.atom,
    required this.onAction,
    required this.child,
    super.key,
  });

  /// The [ActionAtom] to listen to.
  final ActionAtom<A> atom;

  /// The callback to call whenever the [ActionAtom] changes.
  final AtomCallback<A> onAction;

  /// The child widget to build.
  final Widget child;

  @override
  State<ActionBond<A>> createState() => _ActionBondState<A>();
}

class _ActionBondState<T> extends State<ActionBond<T>> {
  @override
  void initState() {
    super.initState();
    widget.atom.addListener(widget.onAction);
  }

  @override
  void dispose() {
    widget.atom.removeListener(widget.onAction);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// {@template action_state_bond}
/// An [ActionStateBond] is a widget that listens to changes on an [ActionAtom]
/// and an [StateAtom] and rebuilds whenever state changes and calls a callback
/// whenever the [ActionAtom] changes.
/// {@endtemplate}
class ActionStateBond<S, A> extends StatelessWidget {
  /// {@macro action_state_bond}
  const ActionStateBond({
    required this.stateAtom,
    required this.actionAtom,
    required this.onAction,
    required this.builder,
    super.key,
  });

  /// The [StateAtom] to listen to.
  final StateAtom<S> stateAtom;

  /// The [ActionAtom] to listen to.
  final ActionAtom<A> actionAtom;

  /// The callback to call whenever the [ActionAtom] changes.
  final AtomCallback<A> onAction;

  /// The [BondBuilder] to use to build the widget.
  final BondBuilder<S> builder;

  @override
  Widget build(BuildContext context) {
    return ActionBond<A>(
      atom: actionAtom,
      onAction: onAction,
      child: StateBond<S>(
        atom: stateAtom,
        builder: builder,
      ),
    );
  }
}
