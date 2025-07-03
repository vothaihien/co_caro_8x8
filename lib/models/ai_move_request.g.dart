// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_move_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiMoveRequest _$AiMoveRequestFromJson(Map<String, dynamic> json) =>
    AiMoveRequest(
      board:
          (json['board'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
      player:
          (json['player'] as List<dynamic>)
              .map((e) => Map<String, int>.from(e as Map))
              .toList(),
      cpu:
          (json['cpu'] as List<dynamic>)
              .map((e) => Map<String, int>.from(e as Map))
              .toList(),
    );

Map<String, dynamic> _$AiMoveRequestToJson(AiMoveRequest instance) =>
    <String, dynamic>{
      'board': instance.board,
      'player': instance.player,
      'cpu': instance.cpu,
    };
