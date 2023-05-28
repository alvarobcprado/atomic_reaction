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
    incrementAtom.addListener(() {
      counterAtom.value++;
    });
  }

  final counterAtom = StateAtom<int>(0);
  final incrementAtom = VoidActionAtom();

  @override
  List<Atom> get atoms => [counterAtom, incrementAtom, inverseCounterAtom];
}

final inverseCounterAtom = StateAtom<int>(0);
final decrementAtom = VoidActionAtom()
  ..addListener(() {
    inverseCounterAtom.value--;
  });

class _MyHomePageState extends State<MyHomePage> {
  final counterMolecule = CounterMolecule();
  void _incrementCounter() {
    counterMolecule.incrementAtom();
    decrementAtom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              atom: counterMolecule.counterAtom,
              builder: (_, value) => Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Text(
              'Inverse:',
            ),
            StateBond(
              atom: inverseCounterAtom,
              builder: (_, value) => Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
