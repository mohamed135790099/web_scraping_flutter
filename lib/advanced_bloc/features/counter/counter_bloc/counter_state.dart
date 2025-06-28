import 'package:equatable/equatable.dart';
sealed class CounterState extends Equatable{
  int count;
  CounterState(this.count);

  @override
  List<Object?> get props => [];
}

class CounterIntial extends CounterState{
   CounterIntial(): super(0);
   @override
   List<Object?> get props => [count];
}

class CounterUpdate extends CounterState{
   CounterUpdate(super.count);
  @override
  List<Object?> get props => [count];
}

