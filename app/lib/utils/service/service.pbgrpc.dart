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
  static final _$loadService = $grpc.ClientMethod<$0.loadData, $0.loadStatus>(
      '/ScoringPoseService/loadService',
      ($0.loadData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.loadStatus.fromBuffer(value));
  static final _$getScore = $grpc.ClientMethod<$0.ImageRequest, $0.ScoreResponse>(
      '/ScoringPoseService/getScore',
      ($0.ImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ScoreResponse.fromBuffer(value));

  ScoringPoseServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.loadStatus> loadService($0.loadData request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$loadService, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScoreResponse> getScore($0.ImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getScore, request, options: options);
  }
}

@$pb.GrpcServiceName('ScoringPoseService')
abstract class ScoringPoseServiceBase extends $grpc.Service {
  $core.String get $name => 'ScoringPoseService';

  ScoringPoseServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.loadData, $0.loadStatus>(
        'loadService',
        loadService_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.loadData.fromBuffer(value),
        ($0.loadStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.ScoreResponse>(
        'getScore',
        getScore_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.ScoreResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.loadStatus> loadService_Pre($grpc.ServiceCall call, $async.Future<$0.loadData> request) async {
    return loadService(call, await request);
  }

  $async.Future<$0.ScoreResponse> getScore_Pre($grpc.ServiceCall call, $async.Future<$0.ImageRequest> request) async {
    return getScore(call, await request);
  }

  $async.Future<$0.loadStatus> loadService($grpc.ServiceCall call, $0.loadData request);
  $async.Future<$0.ScoreResponse> getScore($grpc.ServiceCall call, $0.ImageRequest request);
}
