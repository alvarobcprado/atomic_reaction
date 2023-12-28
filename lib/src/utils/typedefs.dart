/// Typedefs used in the library.
library atomic_reaction.typedefs;

import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:flutter/material.dart';

/// A typedef representing a callback function for an atom with type [T].
typedef AtomCallback<T> = void Function(T value);

/// A typedef representing a callback function for an atom with type [void].
typedef AtomVoidCallback = void Function();

/// A typedef representing a modifier function for a listener to changes of an
/// atom with type [T].
typedef AtomListenerModifier<T> = Stream<T> Function(Stream<T> listener);

/// A typedef representing a builder function for creating a widget based on an
/// atom with type [T].
typedef BondBuilder<T> = Widget Function(BuildContext context, T value);

/// A typedef representing a selector function for a list of atoms.
typedef AtomSelector<T extends Atom<dynamic>> = List<T> Function(List<T> atoms);
