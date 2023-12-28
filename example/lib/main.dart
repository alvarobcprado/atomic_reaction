import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
      modifier: ListenerModifiers.debounceTime(const Duration(seconds: 1)),
    );
  }

  final counterState = StateAtom<int>(0);
  final incrementEvent = EventVoidAtom();
  final decrementEvent = EventVoidAtom();
  final resetEvent = EventVoidAtom();
  final showSnackBarAction = ActionAtom<String>();

  @override
  List<Atom> get atoms => [
        counterState,
        incrementEvent,
        decrementEvent,
        resetEvent,
        showSnackBarAction,
      ];
}

class _MyHomePageState extends State<MyHomePage> {
  final counterMolecule = CounterMolecule();
  void _incrementCounter() {
    counterMolecule.incrementEvent();
  }

  @override
  Widget build(BuildContext context) {
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
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: counterMolecule.decrementEvent,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
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
