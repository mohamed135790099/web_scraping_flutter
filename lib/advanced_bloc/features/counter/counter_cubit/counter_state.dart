import 'package:equatable/equatable.dart';

sealed class CounterState extends Equatable {
  int count=0;
   CounterState(this.count);
}

final class CounterInitial extends CounterState {
  CounterInitial(super.count);
  @override
  List<Object> get props => [count];
}
// this will be used to update the counter in cases including increment and decrement
final class CounterUpdate extends CounterState{
  CounterUpdate(super.count);
  @override
  List<Object> get props => [count];
}


