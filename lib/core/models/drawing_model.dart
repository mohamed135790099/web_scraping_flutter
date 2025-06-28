import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DrawingPoint {
  final double x;
  final double y;
  final double strokeWidth;
  final int color;

  const DrawingPoint({
    required this.x,
    required this.y,
    required this.strokeWidth,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'strokeWidth': strokeWidth,
      'color': color,
    };
  }

  factory DrawingPoint.fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      x: map['x']?.toDouble() ?? 0.0,
      y: map['y']?.toDouble() ?? 0.0,
      strokeWidth: map['strokeWidth']?.toDouble() ?? 2.0,
      color: map['color']?.toInt() ?? 0xFF000000,
    );
  }
}

class DrawingModel extends Equatable {
  final String id;
  final String chatId;
  final List<DrawingPoint> points;
  final DateTime createdAt;
  final String? imageUrl;

  const DrawingModel({
    required this.id,
    required this.chatId,
    required this.points,
    required this.createdAt,
    this.imageUrl,
  });

  factory DrawingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final pointsList = (data['points'] as List<dynamic>?)
            ?.map(
                (point) => DrawingPoint.fromMap(point as Map<String, dynamic>))
            .toList() ??
        [];

    return DrawingModel(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      points: pointsList,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'points': points.map((point) => point.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
    };
  }

  DrawingModel copyWith({
    String? id,
    String? chatId,
    List<DrawingPoint>? points,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return DrawingModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, chatId, points, createdAt, imageUrl];
}
