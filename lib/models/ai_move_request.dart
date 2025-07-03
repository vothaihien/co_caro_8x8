import 'package:json_annotation/json_annotation.dart';

part 'ai_move_request.g.dart';

@JsonSerializable()
class AiMoveRequest {
  final List<int> board;
  final List<Map<String, int>> player;
  final List<Map<String, int>> cpu;

  AiMoveRequest({
    required this.board,
    required this.player,
    required this.cpu,
  });

  factory AiMoveRequest.fromJson(Map<String, dynamic> json) => _$AiMoveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AiMoveRequestToJson(this);
}