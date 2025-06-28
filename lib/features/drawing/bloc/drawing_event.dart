part of 'drawing_bloc.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object?> get props => [];
}

class AddDrawingPoint extends DrawingEvent {
  final DrawingPoint point;
  const AddDrawingPoint(this.point);

  @override
  List<Object?> get props => [point];
}

class ClearCanvas extends DrawingEvent {}

class ChangeColor extends DrawingEvent {
  final Color color;
  const ChangeColor(this.color);

  @override
  List<Object?> get props => [color];
}

class ChangeStrokeWidth extends DrawingEvent {
  final double strokeWidth;
  const ChangeStrokeWidth(this.strokeWidth);

  @override
  List<Object?> get props => [strokeWidth];
}

class SaveDrawing extends DrawingEvent {
  final String drawingId;
  final String chatId;
  final Uint8List imageBytes;
  const SaveDrawing(
      {required this.drawingId,
      required this.chatId,
      required this.imageBytes});

  @override
  List<Object?> get props => [drawingId, chatId, imageBytes];
}

class LoadDrawing extends DrawingEvent {
  final DrawingModel drawing;
  const LoadDrawing(this.drawing);

  @override
  List<Object?> get props => [drawing];
}
