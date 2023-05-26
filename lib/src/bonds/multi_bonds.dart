import 'package:atomic_reaction/src/atoms/state_atom.dart';
import 'package:flutter/material.dart';

class MultiBonds extends StatefulWidget {
  const MultiBonds({
    super.key,
    required this.child,
    required this.atoms,
  });

  final Widget child;
  final List<StateAtom> atoms;

  @override
  State<MultiBonds> createState() => _MultiBondsState();
}

class _MultiBondsState extends State<MultiBonds> {
  @override
  void initState() {
    super.initState();
    for (final atom in widget.atoms) {
      atom.listenAtom(_onAtomChange);
    }
  }

  @override
  void dispose() {
    for (final atom in widget.atoms) {
      atom.removeAtomListener(_onAtomChange);
    }
    super.dispose();
  }

  void _onAtomChange(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
