
import 'package:flutter/material.dart';

class RestorableIntDoublePage extends StatefulWidget {
  const RestorableIntDoublePage({super.key});

  @override
  State<RestorableIntDoublePage> createState() => _RestorableIntDoublePageState();
}

class _RestorableIntDoublePageState extends State<RestorableIntDoublePage> with RestorationMixin {
  final RestorableInt _counter = RestorableInt(0);
  final RestorableDouble _rating = RestorableDouble(2.5);

  @override
  String get restorationId => 'int_double_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'counter');
    registerForRestoration(_rating, 'rating');
  }

  @override
  void dispose() {
    _counter.dispose();
    _rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Int & Double')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Counter: ${_counter.value}', style: const TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: () {
            setState(() => _counter.value++);
          }, child: const Text('Increment')),
          const SizedBox(height: 20),
          Text('Rating: ${_rating.value}', style: const TextStyle(fontSize: 20)),
          Slider(
            value: _rating.value,
            onChanged: (val) => setState(() => _rating.value = val),
            min: 0,
            max: 5,
            divisions: 10,
          ),
        ],
      ),
    );
  }
}
