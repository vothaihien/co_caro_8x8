import 'package:json_annotation/json_annotation.dart';

import 'cpu_move.dart';

part 'cpu_move_data.g.dart';

@JsonSerializable()
class CpuMoveData {
  final CpuMove cpu_move;

  CpuMoveData({required this.cpu_move});

  factory CpuMoveData.fromJson(Map<String, dynamic> json) => _$CpuMoveDataFromJson(json);
  Map<String, dynamic> toJson() => _$CpuMoveDataToJson(this);
}