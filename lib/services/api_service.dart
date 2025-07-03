import 'package:co_caro/models/ai_move_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/ai_move_request.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://dev.api.mightymix.ai/api/v1/caro-ai/next-move")
abstract class ApiService{
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/")
  Future<AiMoveResponse> getAiMove(@Body() AiMoveRequest request);
}