import 'package:json_annotation/json_annotation.dart';

part 'cpu_move.g.dart';

@JsonSerializable()
class CpuMove {
  final int x;
  final int y;

  CpuMove({required this.x, required this.y});

  factory CpuMove.fromJson(Map<String, dynamic> json) => _$CpuMoveFromJson(json);
  Map<String, dynamic> toJson() => _$CpuMoveToJson(this);
}