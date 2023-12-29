import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/bonds/single_bonds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('StateBond', () {
    testWidgets('builds widget correctly', (tester) async {
      const initialValue = 10;
      const updatedValue = 42;
      // Create a StateAtom instance
      final atom = StateAtom<int>(initialValue);

      // Create a widget using StateBond
      final widget = StateBond<int>(
        atom: atom,
        builder: (context, value) {
          return Text(value.toString());
        },
      );

      // Build the widget
      await tester.pumpWidget(TestUtils.build(widget));

      // Verify that the widget is built correctly
      expect(find.text('$initialValue'), findsOneWidget);

      // Update the atom value
      atom.value = updatedValue;

      // Rebuild the widget
      await tester.pump();

      // Verify that the widget is rebuilt with the updated value
      expect(find.text('$updatedValue'), findsOneWidget);
    });
  });

  group('ActionBond', () {
    testWidgets('calls callback on atom change', (tester) async {
      // Create a mock callback function
      var callbackCalled = false;
      void callback(int value) {
        callbackCalled = true;
      }

      // Create an ActionAtom instance
      final atom = ActionAtom<int>();

      // Create a widget using ActionBond
      final widget = ActionBond<int>(
        atom: atom,
        onAction: callback,
        child: Container(),
      );

      // Build the widget
      await tester.pumpWidget(TestUtils.build(widget));

      // Trigger an action on the atom
      atom(42);

      await tester.pump();

      // Verify that the callback is called
      expect(callbackCalled, isTrue);
    });
  });

  group('ActionStateBond', () {
    testWidgets('rebuilds widget correctly on state change', (tester) async {
      const initialState = 'Initial State';
      const updatedState = 'Updated State';
      const actionValue = 'Action Value';

      // Create a StateAtom instance
      final stateAtom = StateAtom<String>(initialState);

      // Create an ActionAtom instance
      final actionAtom = ActionAtom<String>();

      // Create a mock callback function
      var callbackCalled = false;
      void callback(String value) {
        callbackCalled = true;
      }

      // Create a widget using ActionStateBond
      final widget = ActionStateBond<String, String>(
        stateAtom: stateAtom,
        actionAtom: actionAtom,
        onAction: callback,
        builder: (context, state) {
          return Text(state);
        },
      );

      // Build the widget
      await tester.pumpWidget(TestUtils.build(widget));

      // Verify that the widget is built correctly with the initial state
      expect(find.text(initialState), findsOneWidget);

      // Trigger an action on the action atom
      actionAtom(actionValue);

      // Rebuild the widget
      await tester.pump();

      // Verify that the callback is called
      expect(callbackCalled, isTrue);

      // Update the state atom value
      stateAtom.value = updatedState;

      // Rebuild the widget
      await tester.pumpAndSettle();

      // Verify that the widget is rebuilt with the updated state
      expect(find.text(updatedState), findsOneWidget);
    });
  });
}
