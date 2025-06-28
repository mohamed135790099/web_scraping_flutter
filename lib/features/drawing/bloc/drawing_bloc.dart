import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../../core/models/drawing_model.dart';
import '../../../core/services/firebase_service.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final FirebaseService _firebaseService;

  DrawingBloc(this._firebaseService) : super(DrawingInitial()) {
    on<AddDrawingPoint>(_onAddDrawingPoint);
    on<ClearCanvas>(_onClearCanvas);
    on<ChangeColor>(_onChangeColor);
    on<ChangeStrokeWidth>(_onChangeStrokeWidth);
    on<SaveDrawing>(_onSaveDrawing);
    on<LoadDrawing>(_onLoadDrawing);
  }

  void _onAddDrawingPoint(
    AddDrawingPoint event,
    Emitter<DrawingState> emit,
  ) {
    final currentState = state;
    if (currentState is DrawingActive) {
      final newPoints = List<DrawingPoint>.from(currentState.points)
        ..add(event.point);

      emit(DrawingActive(
        points: newPoints,
        color: currentState.color,
        strokeWidth: currentState.strokeWidth,
      ));
    }
  }

  void _onClearCanvas(
    ClearCanvas event,
    Emitter<DrawingState> emit,
  ) {
    emit(DrawingActive(
      points: [],
      color: state is DrawingActive
          ? (state as DrawingActive).color
          : Colors.black,
      strokeWidth:
          state is DrawingActive ? (state as DrawingActive).strokeWidth : 2.0,
    ));
  }

  void _onChangeColor(
    ChangeColor event,
    Emitter<DrawingState> emit,
  ) {
    final currentState = state;
    if (currentState is DrawingActive) {
      emit(DrawingActive(
        points: currentState.points,
        color: event.color,
        strokeWidth: currentState.strokeWidth,
      ));
    } else {
      emit(DrawingActive(
        points: [],
        color: event.color,
        strokeWidth: 2.0,
      ));
    }
  }

  void _onChangeStrokeWidth(
    ChangeStrokeWidth event,
    Emitter<DrawingState> emit,
  ) {
    final currentState = state;
    if (currentState is DrawingActive) {
      emit(DrawingActive(
        points: currentState.points,
        color: currentState.color,
        strokeWidth: event.strokeWidth,
      ));
    } else {
      emit(DrawingActive(
        points: [],
        color: Colors.black,
        strokeWidth: event.strokeWidth,
      ));
    }
  }

  Future<void> _onSaveDrawing(
    SaveDrawing event,
    Emitter<DrawingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DrawingActive || currentState.points.isEmpty) {
      emit(DrawingFailure('No drawing to save'));
      return;
    }

    emit(DrawingSaving());

    try {
      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        event.imageBytes,
        quality: 100,
        name: 'drawing_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        // Upload to Firebase Storage
        final tempFile = File('${Directory.systemTemp.path}/drawing.jpg');
        await tempFile.writeAsBytes(event.imageBytes);

        final imageUrl = await _firebaseService.uploadDrawingImage(tempFile);

        // Save drawing data to Firestore
        final drawing = DrawingModel(
          id: event.drawingId,
          chatId: event.chatId,
          points: currentState.points,
          createdAt: DateTime.now(),
          imageUrl: imageUrl,
        );

        await _firebaseService.saveDrawing(drawing);

        emit(DrawingSaved(imageUrl: imageUrl));
      } else {
        emit(DrawingFailure('Failed to save drawing'));
      }
    } catch (e) {
      emit(DrawingFailure('Failed to save drawing: $e'));
    }
  }

  void _onLoadDrawing(
    LoadDrawing event,
    Emitter<DrawingState> emit,
  ) {
    emit(DrawingActive(
      points: event.drawing.points,
      color: Colors.black,
      strokeWidth: 2.0,
    ));
  }
}
