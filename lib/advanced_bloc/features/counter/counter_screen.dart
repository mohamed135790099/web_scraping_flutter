import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_bloc/counter_bloc.dart';
import 'counter_bloc/counter_event.dart';
import 'counter_bloc/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Counter Screen'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder<CounterBloc, CounterState>(
                  builder: (context, state) {
                    return Text(
                      'Counter Value: ${state.count}',
                      style: const TextStyle(fontSize: 24),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => context.read<CounterBloc>().add(IncrementCounterEvent()),
                  child: const Text('Increment Counter'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.read<CounterBloc>().add(DecrementCounterEvent()),
                  child: const Text('Decrement Counter'),
                ),
              ],
            ),
          ),
    );
  }
}
