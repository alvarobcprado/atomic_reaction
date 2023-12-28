import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/utils/typedefs.dart';
import 'package:flutter/foundation.dart';

/// A [Molecule] is a collection of [Atom]s that are related to each other.
/// It is used to group [Atom]s together and dispose them at once.
abstract class Molecule {
  /// Listens to the given [atom] and calls the [callback] whenever the [atom]
  /// changes.
  ///
  /// Optionally, you can pass a [modifier] to modify the provided [atom] stream
  /// before listening to it.
  void on<T>(
    EventAtom<T> atom,
    AtomCallback<T> callback, {
    AtomListenerModifier<T>? modifier,
  }) {
    if (!atoms.contains(atom)) {
      throw ArgumentError(
        'The provided atom is not part of this molecule. '
        'Please make sure to add it to the atoms list.',
      );
    }

    atom.addListener(callback, modifier: modifier);
  }

  /// The [Atom]s in the [Molecule].
  ///
  /// This getter is used to dispose all [Atom]s in the [Molecule].
  // ignore: strict_raw_type
  List<Atom> get atoms;

  /// Disposes all [Atom]s in the [Molecule].
  @mustCallSuper
  void dispose() {
    for (final atom in atoms) {
      atom.dispose();
    }
  }
}
