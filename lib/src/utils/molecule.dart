import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:flutter/foundation.dart';

abstract class Molecule {
  @mustCallSuper
  void dispose() {
    for (var atom in atoms) {
      atom.dispose();
    }
  }

  List<Atom> get atoms;
}
