// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_move_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiMoveResponse _$AiMoveResponseFromJson(Map<String, dynamic> json) =>
    AiMoveResponse(
      message: json['message'] as String,
      data: CpuMoveData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AiMoveResponseToJson(AiMoveResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
