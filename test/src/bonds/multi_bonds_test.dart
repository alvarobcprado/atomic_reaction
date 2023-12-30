import 'dart:async';

import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils.dart';

class MockMolecule extends Mock implements Molecule {}

class MockStateAtom<T> extends Mock implements StateAtom<T> {}

class MockActionAtom<T> extends Mock implements ActionAtom<T> {}

void main() {
  group('StateMoleculeBond', () {
    late MockMolecule molecule;
    late WidgetBuilder builder;
    late StateAtom<int> atom1;
    late StateAtom<String> atom2;
    late AtomSelector<StateAtom<dynamic>>? selector;
    late int buildCount;

    setUp(() {
      buildCount = 0;
      molecule = MockMolecule();
      atom1 = MockStateAtom<int>();
      atom2 = MockStateAtom<String>();
      when(() => molecule.atoms).thenReturn([atom1, atom2]);
      when(() => atom1.stream).thenAnswer((_) => Stream.value(0));
      when(() => atom2.stream).thenAnswer((_) => Stream.value('0'));
      builder = (context) => Text('test ${buildCount++}');
      selector = null;
    });

    testWidgets('renders the widget', (WidgetTester tester) async {
      final widget = StateMoleculeBond(
        molecule: molecule,
        builder: builder,
      );
      await tester.pumpWidget(TestUtils.build(widget));

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('listens to all StateAtoms in the molecule',
        (WidgetTester tester) async {
      final widget = StateMoleculeBond(
        molecule: molecule,
        builder: builder,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      verify(() => atom1.stream).called(1);
      verify(() => atom2.stream).called(1);
    });

    testWidgets('listens to selected StateAtoms in the molecule',
        (WidgetTester tester) async {
      selector = (atoms) => atoms.whereType<MockStateAtom<int>>().toList();

      final widget = StateMoleculeBond(
        molecule: molecule,
        builder: builder,
        selector: selector,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      verify(() => atom1.stream).called(1);
      verifyNever(() => atom2.stream);
    });

    testWidgets('calls the builder when any StateAtom changes', (
      WidgetTester tester,
    ) async {
      atom1 = StateAtom<int>(0);
      atom2 = StateAtom<String>('0');
      when(() => molecule.atoms).thenReturn([atom1, atom2]);

      final widget = StateMoleculeBond(
        molecule: molecule,
        builder: builder,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      expect(buildCount, equals(1));

      atom1.value = 2;

      await tester.pumpAndSettle();

      expect(buildCount, equals(2));

      atom2.value = '2';

      await tester.pumpAndSettle();

      expect(buildCount, equals(3));
    });

    testWidgets('calls the builder only when selected StateAtom changes', (
      WidgetTester tester,
    ) async {
      atom1 = StateAtom<int>(0);
      atom2 = StateAtom<String>('0');
      when(() => molecule.atoms).thenReturn([atom1, atom2]);
      selector = (atoms) => atoms.whereType<StateAtom<int>>().toList();

      final widget = StateMoleculeBond(
        molecule: molecule,
        builder: builder,
        selector: selector,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      await tester.pumpAndSettle();

      expect(buildCount, equals(1));

      atom1.value = 2;

      await tester.pumpAndSettle();

      expect(buildCount, equals(2));

      atom2.value = '2';

      await tester.pumpAndSettle();

      expect(buildCount, equals(2));
    });
  });

  group('ActionMoleculeBond', () {
    late int callbackCount;
    late MockMolecule molecule;
    late VoidCallback onAction;
    late Widget child;
    late AtomSelector<ActionAtom<dynamic>>? selector;
    late ActionAtom<int> actionAtom1;
    late ActionAtom<String> actionAtom2;

    setUp(() {
      callbackCount = 0;
      molecule = MockMolecule();
      onAction = () => callbackCount++;
      child = Container();
      selector = null;
      actionAtom1 = MockActionAtom<int>();
      actionAtom2 = MockActionAtom<String>();
      when(() => molecule.atoms).thenReturn([actionAtom1, actionAtom2]);
      when(() => actionAtom1.stream).thenAnswer((_) => const Stream.empty());
      when(() => actionAtom2.stream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders the widget', (WidgetTester tester) async {
      final widget = ActionMoleculeBond(
        molecule: molecule,
        onAction: onAction,
        child: child,
      );
      await tester.pumpWidget(TestUtils.build(widget));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('listens to all ActionAtoms in the molecule',
        (WidgetTester tester) async {
      final widget = ActionMoleculeBond(
        molecule: molecule,
        onAction: onAction,
        child: child,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      verify(() => actionAtom1.stream).called(1);
      verify(() => actionAtom2.stream).called(1);
    });

    testWidgets('listens to selected ActionAtoms in the molecule',
        (WidgetTester tester) async {
      selector = (atoms) => atoms.whereType<MockActionAtom<int>>().toList();

      final widget = ActionMoleculeBond(
        molecule: molecule,
        onAction: onAction,
        selector: selector,
        child: child,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      verify(() => actionAtom1.stream).called(1);
      verifyNever(() => actionAtom2.stream);
    });

    testWidgets('calls the onAction callback when any ActionAtom changes', (
      WidgetTester tester,
    ) async {
      actionAtom1 = ActionAtom<int>();
      actionAtom2 = ActionAtom<String>();
      when(() => molecule.atoms).thenReturn([actionAtom1, actionAtom2]);

      final widget = ActionMoleculeBond(
        molecule: molecule,
        onAction: onAction,
        child: child,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      await tester.pumpAndSettle();

      expect(callbackCount, equals(0));

      actionAtom1(0);

      await tester.pumpAndSettle();

      expect(callbackCount, equals(1));

      actionAtom2('0');

      await tester.pumpAndSettle();

      expect(callbackCount, equals(2));
    });

    testWidgets(
        'calls the onAction callback only when selected ActionAtom changes', (
      WidgetTester tester,
    ) async {
      actionAtom1 = ActionAtom<int>();
      actionAtom2 = ActionAtom<String>();
      when(() => molecule.atoms).thenReturn([actionAtom1, actionAtom2]);

      selector = (atoms) => atoms.whereType<ActionAtom<int>>().toList();

      final widget = ActionMoleculeBond(
        molecule: molecule,
        onAction: onAction,
        selector: selector,
        child: child,
      );

      await tester.pumpWidget(TestUtils.build(widget));

      await tester.pumpAndSettle();

      expect(callbackCount, equals(0));

      actionAtom1(0);

      await tester.pumpAndSettle();

      expect(callbackCount, equals(1));

      actionAtom2('0');

      await tester.pumpAndSettle();

      expect(callbackCount, equals(1));
    });
  });
}
