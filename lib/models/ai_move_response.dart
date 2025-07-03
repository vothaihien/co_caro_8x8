import 'package:json_annotation/json_annotation.dart';

import 'cpu_move_data.dart';

part 'ai_move_response.g.dart';

@JsonSerializable()
class AiMoveResponse {
  final String message;
  final CpuMoveData data;

  AiMoveResponse({required this.message, required this.data});

  factory AiMoveResponse.fromJson(Map<String, dynamic> json) => _$AiMoveResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AiMoveResponseToJson(this);
}