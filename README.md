# Atomic Reaction - Flutter Package

**Atomic Reaction** is a state management library for Flutter that utilizes the atomic design principle to create modular and scalable state management solutions. It's designed to provide a clear structure for managing state, events, and actions within your Flutter applications.

## Getting Started

To use Atomic Reaction in your Flutter project, follow these simple steps:

1. Add the dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     atomic_reaction: ^1.0.0
   ```

   Replace `^1.0.0` with the latest version available on [pub.dev](https://pub.dev/packages/atomic_reaction).

2. Run `flutter pub get` to install the package.

3. Import the library in your Dart code:

   ```dart
   import 'package:atomic_reaction/atomic_reaction.dart';
   ```

## Example Usage

Below is a basic example demonstrating the usage of Atomic Reaction to manage state and events in a Flutter application. This example includes a simple counter app.

```dart
// Define a Molecule to manage the atoms interactions
class CounterMolecule extends Molecule {
  CounterMolecule() {
    on(incrementEvent, (_) => counterState.value++);
    on(decrementEvent, (_) => counterState.value--);
    on(
      resetEvent,
      (_) {
        counterState.value = 0;
        showSnackBarAction('Counter reseted');
      },
      // Use a modifier to the event to prevent spamming
      modifier: ListenerModifiers.debounceTime(const Duration(seconds: 1)),
    );
  }

  // Define state, events, and actions
  final counterState = StateAtom<int>(0);
  final incrementEvent = EventVoidAtom();
  final decrementEvent = EventVoidAtom();
  final resetEvent = EventVoidAtom();
  final showSnackBarAction = ActionAtom<String>();

  // Declare the atoms that the molecule manages
  @override
  List<Atom> get atoms => [
        counterState,
        incrementEvent,
        decrementEvent,
        resetEvent,
        showSnackBarAction,
      ];
}

// Define the home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final counterMolecule = CounterMolecule();

  @override
  Widget build(BuildContext context) {
    // Handle the actions triggered by the molecule
    return ActionBond(
      atom: counterMolecule.showSnackBarAction,
      onAction: (snackBarText) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackBarText)),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              // Listen to the state atoms to get notified when the state changes
              StateBond(
                atom: counterMolecule.counterState,
                builder: (_, value) => Text(
                  '$value',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use the event atom to trigger an event in the molecule
            FloatingActionButton(
              onPressed: counterMolecule.incrementEvent,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 8),
            // Use the event atom to trigger an event in the molecule
            FloatingActionButton(
              onPressed: counterMolecule.decrementEvent,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            // Use the event atom to trigger an event in the molecule
            FloatingActionButton(
              onPressed: counterMolecule.resetEvent,
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Documentation

Visit the [Atomic Reaction GitHub repository](https://github.com/example/atomic_reaction) for detailed documentation, guides, and more examples.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.