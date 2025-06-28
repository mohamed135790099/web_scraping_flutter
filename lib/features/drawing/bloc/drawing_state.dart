part of 'drawing_bloc.dart';

abstract class DrawingState extends Equatable {
  const DrawingState();

  @override
  List<Object?> get props => [];
}

class DrawingInitial extends DrawingState {}

class DrawingActive extends DrawingState {
  final List<DrawingPoint> points;
  final Color color;
  final double strokeWidth;

  const DrawingActive({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  @override
  List<Object?> get props => [points, color, strokeWidth];
}

class DrawingSaving extends DrawingState {}

class DrawingSaved extends DrawingState {
  final String imageUrl;
  const DrawingSaved({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class DrawingFailure extends DrawingState {
  final String message;
  const DrawingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
