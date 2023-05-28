import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/cupertino.dart';

typedef BondBuilder<T> = Widget Function(BuildContext context, T value);

/// A [StateBond] is a widget that listens to changes on an [StateAtom] and rebuilds
/// whenever the [StateAtom] changes.
class StateBond<T> extends StatelessWidget {
  const StateBond({
    required this.atom,
    required this.builder,
    super.key,
  });

  final StateAtom<T> atom;
  final BondBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: atom.stream,
      builder: (context, snapshot) {
        final currentValue = snapshot.data;
        if (currentValue == null) {
          return const SizedBox.shrink();
        }
        return builder(context, currentValue);
      },
    );
  }
}

class ActionBond<T> extends StatefulWidget {
  const ActionBond({
    required this.atom,
    required this.onAction,
    required this.child,
    super.key,
  });

  final ActionAtom<T> atom;
  final void Function(T action) onAction;
  final Widget child;

  @override
  State<ActionBond<T>> createState() => _ActionBondState<T>();
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

class ActionStateBond<S, A> extends StatelessWidget {
  const ActionStateBond({
    Key? key,
    required this.stateAtom,
    required this.actionAtom,
    required this.onAction,
    required this.builder,
  }) : super(key: key);

  final StateAtom<S> stateAtom;
  final ActionAtom<A> actionAtom;
  final void Function(A action) onAction;
  final Widget Function(BuildContext context, S value) builder;

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
