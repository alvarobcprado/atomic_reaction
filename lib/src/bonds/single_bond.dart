import 'package:atomic_reaction/src/atoms/state_atom.dart';
import 'package:flutter/cupertino.dart';

class SingleBond<T> extends StatefulWidget {
  const SingleBond({
    required this.atom,
    required this.child,
    super.key,
  });

  final StateAtom<T> atom;
  final Widget child;

  @override
  State<SingleBond<T>> createState() => _SingleBondState<T>();
}

class _SingleBondState<T> extends State<SingleBond<T>> {
  Key childKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    widget.atom.listenAtom(_onAtomChange);
  }

  @override
  void dispose() {
    widget.atom.removeAtomListener(_onAtomChange);
    super.dispose();
  }

  void _onAtomChange(T value) {
    setState(() {
      childKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: childKey,
      child: widget.child,
    );
  }
}
