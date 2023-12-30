import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/molecules/molecule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventAtom<T> extends Mock implements EventAtom<T> {}

void main() {
  group('Molecule', () {
    late MyMolecule molecule;
    late MockEventAtom<int> atom1;
    late MockEventAtom<String> atom2;
    late MockEventAtom<int> outsideAtom;

    setUp(() {
      molecule = MyMolecule();
      atom1 = molecule.atom1;
      atom2 = molecule.atom2;
      outsideAtom = MockEventAtom<int>();
    });

    test('throws an error if atom is not part of the molecule', () {
      expect(
        () => molecule.on(outsideAtom, (value) {}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('calls the callback when EventAtom changes', () {
      void callback(int value) {}

      molecule.on(atom1, callback);

      verify(() => atom1.addListener(callback, modifier: null)).called(1);
    });

    test('disposes all atoms in the molecule', () {
      molecule.atoms.addAll([atom1, atom2]);

      molecule.dispose();

      verify(() => atom1.dispose()).called(1);
      verify(() => atom2.dispose()).called(1);
    });
  });
}

class MyMolecule extends Molecule {
  final atom1 = MockEventAtom<int>();
  final atom2 = MockEventAtom<String>();

  @override
  List<Atom<dynamic>> get atoms => [
        atom1,
        atom2,
      ];
}
