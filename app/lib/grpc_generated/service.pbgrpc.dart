//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('ScoringPoseService')
class ScoringPoseServiceClient extends $grpc.Client {
  static final _$loadService = $grpc.ClientMethod<$0.LoadData, $0.LoadStatus>(
      '/ScoringPoseService/loadService',
      ($0.LoadData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoadStatus.fromBuffer(value));
  static final _$loadGame = $grpc.ClientMethod<$0.GameRequest, $0.GameStatus>(
      '/ScoringPoseService/loadGame',
      ($0.GameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameStatus.fromBuffer(value));
  static final _$getScore = $grpc.ClientMethod<$0.TimeRequest, $0.ScoreResponse>(
      '/ScoringPoseService/getScore',
      ($0.TimeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ScoreResponse.fromBuffer(value));
  static final _$endGame = $grpc.ClientMethod<$0.EndRequest, $0.EndStatus>(
      '/ScoringPoseService/endGame',
      ($0.EndRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EndStatus.fromBuffer(value));

  ScoringPoseServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LoadStatus> loadService($0.LoadData request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$loadService, request, options: options);
  }

  $grpc.ResponseFuture<$0.GameStatus> loadGame($0.GameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$loadGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScoreResponse> getScore($0.TimeRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getScore, request, options: options);
  }

  $grpc.ResponseFuture<$0.EndStatus> endGame($0.EndRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$endGame, request, options: options);
  }
}

@$pb.GrpcServiceName('ScoringPoseService')
abstract class ScoringPoseServiceBase extends $grpc.Service {
  $core.String get $name => 'ScoringPoseService';

  ScoringPoseServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoadData, $0.LoadStatus>(
        'loadService',
        loadService_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoadData.fromBuffer(value),
        ($0.LoadStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GameRequest, $0.GameStatus>(
        'loadGame',
        loadGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GameRequest.fromBuffer(value),
        ($0.GameStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TimeRequest, $0.ScoreResponse>(
        'getScore',
        getScore_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TimeRequest.fromBuffer(value),
        ($0.ScoreResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EndRequest, $0.EndStatus>(
        'endGame',
        endGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EndRequest.fromBuffer(value),
        ($0.EndStatus value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoadStatus> loadService_Pre($grpc.ServiceCall call, $async.Future<$0.LoadData> request) async {
    return loadService(call, await request);
  }

  $async.Future<$0.GameStatus> loadGame_Pre($grpc.ServiceCall call, $async.Future<$0.GameRequest> request) async {
    return loadGame(call, await request);
  }

  $async.Future<$0.ScoreResponse> getScore_Pre($grpc.ServiceCall call, $async.Future<$0.TimeRequest> request) async {
    return getScore(call, await request);
  }

  $async.Future<$0.EndStatus> endGame_Pre($grpc.ServiceCall call, $async.Future<$0.EndRequest> request) async {
    return endGame(call, await request);
  }

  $async.Future<$0.LoadStatus> loadService($grpc.ServiceCall call, $0.LoadData request);
  $async.Future<$0.GameStatus> loadGame($grpc.ServiceCall call, $0.GameRequest request);
  $async.Future<$0.ScoreResponse> getScore($grpc.ServiceCall call, $0.TimeRequest request);
  $async.Future<$0.EndStatus> endGame($grpc.ServiceCall call, $0.EndRequest request);
}
