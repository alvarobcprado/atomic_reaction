import 'dart:async';

import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StateMoleculeBond<T extends Molecule> extends StatelessWidget {
  const StateMoleculeBond({
    required this.molecule,
    required this.builder,
    super.key,
  });

  final T molecule;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: const Stream.empty().mergeWith(
        molecule.atoms.whereType<StateAtom>().map((e) => e.stream),
      ),
      builder: (context, snapshot) {
        return builder(context);
      },
    );
  }
}

class ActionMoleculeBond<T extends Molecule> extends StatefulWidget {
  const ActionMoleculeBond({
    required this.molecule,
    required this.onAction,
    required this.child,
    super.key,
  });

  final T molecule;
  final void Function(dynamic action) onAction;
  final Widget child;

  @override
  State<ActionMoleculeBond<T>> createState() => _ActionMoleculeBondState<T>();
}

class _ActionMoleculeBondState<T extends Molecule>
    extends State<ActionMoleculeBond<T>> {
  @override
  void initState() {
    super.initState();
    widget.molecule.atoms
        .whereType<ActionAtom>()
        .map((e) => e.addListener(widget.onAction));
  }

  @override
  void dispose() {
    widget.molecule.atoms
        .whereType<ActionAtom>()
        .forEach((e) => e.removeListener(widget.onAction));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
