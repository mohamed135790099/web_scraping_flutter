import 'package:flutter_bloc/flutter_bloc.dart';
import '/advanced_bloc/features/counter/counter_bloc/counter_event.dart';
import '/advanced_bloc/features/counter/counter_bloc/counter_state.dart';

import '../counter_cubit/counter_state.dart';



class CounterBloc extends Bloc<CounterEvent, CounterState>{
  CounterBloc():super(CounterIntial()){
    _increment();
    _decrement();
  }

  void _increment() {
     on<IncrementCounterEvent>((event,emit){
      emit(CounterUpdate(state.count+1));
    });
  }
  void _decrement() {
    on<DecrementCounterEvent>((event,emit){
      emit(CounterUpdate(state.count-1));
    });
  }

}