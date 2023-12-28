import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:flutter/foundation.dart';

/// A [Molecule] is a collection of [Atom]s that are related to each other.
/// It is used to group [Atom]s together and dispose them at once.
abstract class Molecule {
  /// Disposes all [Atom]s in the [Molecule].
  @mustCallSuper
  void dispose() {
    for (final atom in atoms) {
      atom.dispose();
    }
  }

  /// The [Atom]s in the [Molecule].
  ///
  /// This getter is used to dispose all [Atom]s in the [Molecule].
  // ignore: strict_raw_type
  List<Atom> get atoms;
}
