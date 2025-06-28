import 'package:bloc/bloc.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/counter/counter_cubit/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitial(0));

   void increment(){
     final currentCount = state.count;
     emit(CounterUpdate(currentCount+1));
   }

   void decrement(){
     final decrementCount= state.count;
     emit(CounterUpdate(decrementCount-1));
   }
   void reset(){
     emit(CounterInitial(0));
   }
}
