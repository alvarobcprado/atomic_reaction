import 'dart:async';

import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// {@template state_molecule_bond}
/// A [StateMoleculeBond] is a widget that listens to changes on any [StateAtom]
/// in a [Molecule] and rebuilds whenever any of the [StateAtom]s change.
///
/// The rebuild can be limited to a specific [StateAtom] by using the [selector]
/// parameter to specify the [StateAtom]s to listen to.
/// {@endtemplate}
class StateMoleculeBond<T extends Molecule> extends StatelessWidget {
  /// {@macro state_molecule_bond}
  const StateMoleculeBond({
    required this.molecule,
    required this.builder,
    this.selector,
    super.key,
  });

  /// The [Molecule] to listen to.
  final T molecule;

  /// The Builder to use to build the widget.
  final WidgetBuilder builder;

  /// The [StateAtom]s selector to listen to.
  final AtomSelector<StateAtom<dynamic>>? selector;

  Stream<dynamic> _getStream() {
    final atoms = molecule.atoms.whereType<StateAtom<dynamic>>().toList();
    if (selector != null) {
      return Rx.merge(selector!(atoms).map((e) => e.stream));
    }
    return Rx.merge(atoms.map((e) => e.stream));
  }

  @override
  Widget build(BuildContext context) {
    final stream = _getStream();
    return StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, snapshot) {
        return builder(context);
      },
    );
  }
}

/// {@template action_molecule_bond}
/// An [ActionMoleculeBond] is a widget that listens to changes on any
/// [ActionAtom] in a [Molecule] and calls a callback whenever any of the
/// [ActionAtom]s change.
///
/// The callback can be limited to a specific [ActionAtom] by using the
/// [selector] parameter to specify the [ActionAtom]s to listen to.
/// {@endtemplate}
class ActionMoleculeBond<T extends Molecule> extends StatefulWidget {
  /// {@macro action_molecule_bond}
  const ActionMoleculeBond({
    required this.molecule,
    required this.onAction,
    required this.child,
    this.selector,
    super.key,
  });

  /// The [Molecule] to listen to.
  final T molecule;

  /// The callback to call whenever the [ActionAtom] changes.
  final VoidCallback onAction;

  /// The child widget to build.
  final Widget child;

  /// The [ActionAtom]s selector to listen to.
  final AtomSelector<ActionAtom<dynamic>>? selector;

  @override
  State<ActionMoleculeBond<T>> createState() => _ActionMoleculeBondState<T>();
}

class _ActionMoleculeBondState<T extends Molecule>
    extends State<ActionMoleculeBond<T>> {
  late StreamSubscription<dynamic> _subscription;

  Stream<dynamic> _getStream() {
    final availableAtoms = widget.molecule.atoms;
    final atoms = availableAtoms.whereType<ActionAtom<dynamic>>().toList();
    if (widget.selector != null) {
      return Rx.merge(widget.selector!(atoms).map((e) => e.stream));
    }
    return Rx.merge(atoms.map((e) => e.stream));
  }

  void _onAction(dynamic _) {
    widget.onAction();
  }

  @override
  void initState() {
    super.initState();
    _subscription = _getStream().listen(_onAction);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// {@template action_state_molecule_bond}
/// An [ActionStateMoleculeBond] is a widget that listens to changes on any
/// [ActionAtom] or [StateAtom] in a [Molecule] and calls a callback whenever
/// any of the [ActionAtom]s change and rebuilds whenever any of the [StateAtom]
/// change.
///
/// The callback can be limited to a specific [ActionAtom] by using the
/// [actionSelector] parameter to specify the [ActionAtom]s to listen to.
///
/// The rebuild can be limited to a specific [StateAtom] by using the
/// [stateSelector] parameter to specify the [StateAtom]s to listen to.
/// {@endtemplate}
class ActionStateMoleculeBond<T extends Molecule> extends StatelessWidget {
  /// {@macro action_state_molecule_bond}
  const ActionStateMoleculeBond({
    required this.molecule,
    required this.onAction,
    required this.builder,
    this.actionSelector,
    this.stateSelector,
    super.key,
  });

  /// The [Molecule] to listen to.
  final T molecule;

  /// The callback to call whenever the [ActionAtom] changes.
  final VoidCallback onAction;

  /// The Builder to use to build the widget.
  final WidgetBuilder builder;

  /// The [ActionAtom]s selector to listen to.
  final AtomSelector<ActionAtom<dynamic>>? actionSelector;

  /// The [StateAtom]s selector to listen to.
  final AtomSelector<StateAtom<dynamic>>? stateSelector;

  @override
  Widget build(BuildContext context) {
    return ActionMoleculeBond(
      onAction: onAction,
      molecule: molecule,
      selector: actionSelector,
      child: StateMoleculeBond(
        molecule: molecule,
        builder: builder,
        selector: stateSelector,
      ),
    );
  }
}
