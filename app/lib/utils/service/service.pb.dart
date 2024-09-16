//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EmptyMessage extends $pb.GeneratedMessage {
  factory EmptyMessage({
    $core.String? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  EmptyMessage._() : super();
  factory EmptyMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EmptyMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EmptyMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EmptyMessage clone() => EmptyMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EmptyMessage copyWith(void Function(EmptyMessage) updates) => super.copyWith((message) => updates(message as EmptyMessage)) as EmptyMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmptyMessage create() => EmptyMessage._();
  EmptyMessage createEmptyInstance() => create();
  static $pb.PbList<EmptyMessage> createRepeated() => $pb.PbList<EmptyMessage>();
  @$core.pragma('dart2js:noInline')
  static EmptyMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EmptyMessage>(create);
  static EmptyMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class LoadStatus extends $pb.GeneratedMessage {
  factory LoadStatus({
    $core.String? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  LoadStatus._() : super();
  factory LoadStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoadStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoadStatus', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoadStatus clone() => LoadStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoadStatus copyWith(void Function(LoadStatus) updates) => super.copyWith((message) => updates(message as LoadStatus)) as LoadStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadStatus create() => LoadStatus._();
  LoadStatus createEmptyInstance() => create();
  static $pb.PbList<LoadStatus> createRepeated() => $pb.PbList<LoadStatus>();
  @$core.pragma('dart2js:noInline')
  static LoadStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoadStatus>(create);
  static LoadStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class GameRequest extends $pb.GeneratedMessage {
  factory GameRequest({
    $core.String? songTitle,
    $core.int? numberOfPlayers,
    $core.double? cameraAngle,
    $core.int? gameSpeed,
  }) {
    final $result = create();
    if (songTitle != null) {
      $result.songTitle = songTitle;
    }
    if (numberOfPlayers != null) {
      $result.numberOfPlayers = numberOfPlayers;
    }
    if (cameraAngle != null) {
      $result.cameraAngle = cameraAngle;
    }
    if (gameSpeed != null) {
      $result.gameSpeed = gameSpeed;
    }
    return $result;
  }
  GameRequest._() : super();
  factory GameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'songTitle', protoName: 'songTitle')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'numberOfPlayers', $pb.PbFieldType.O3, protoName: 'numberOfPlayers')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'cameraAngle', $pb.PbFieldType.OF, protoName: 'cameraAngle')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'gameSpeed', $pb.PbFieldType.O3, protoName: 'gameSpeed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameRequest clone() => GameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameRequest copyWith(void Function(GameRequest) updates) => super.copyWith((message) => updates(message as GameRequest)) as GameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameRequest create() => GameRequest._();
  GameRequest createEmptyInstance() => create();
  static $pb.PbList<GameRequest> createRepeated() => $pb.PbList<GameRequest>();
  @$core.pragma('dart2js:noInline')
  static GameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameRequest>(create);
  static GameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get songTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set songTitle($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSongTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearSongTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get numberOfPlayers => $_getIZ(1);
  @$pb.TagNumber(2)
  set numberOfPlayers($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNumberOfPlayers() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumberOfPlayers() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get cameraAngle => $_getN(2);
  @$pb.TagNumber(3)
  set cameraAngle($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCameraAngle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCameraAngle() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get gameSpeed => $_getIZ(3);
  @$pb.TagNumber(4)
  set gameSpeed($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGameSpeed() => $_has(3);
  @$pb.TagNumber(4)
  void clearGameSpeed() => clearField(4);
}

class GameStatus extends $pb.GeneratedMessage {
  factory GameStatus({
    $core.int? numberOfPlayers,
    $core.String? status,
  }) {
    final $result = create();
    if (numberOfPlayers != null) {
      $result.numberOfPlayers = numberOfPlayers;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  GameStatus._() : super();
  factory GameStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameStatus', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'numberOfPlayers', $pb.PbFieldType.O3, protoName: 'numberOfPlayers')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStatus clone() => GameStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStatus copyWith(void Function(GameStatus) updates) => super.copyWith((message) => updates(message as GameStatus)) as GameStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStatus create() => GameStatus._();
  GameStatus createEmptyInstance() => create();
  static $pb.PbList<GameStatus> createRepeated() => $pb.PbList<GameStatus>();
  @$core.pragma('dart2js:noInline')
  static GameStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStatus>(create);
  static GameStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numberOfPlayers => $_getIZ(0);
  @$pb.TagNumber(1)
  set numberOfPlayers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumberOfPlayers() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumberOfPlayers() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class TimeRequest extends $pb.GeneratedMessage {
  factory TimeRequest({
    $core.int? time,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  TimeRequest._() : super();
  factory TimeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TimeRequest', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeRequest clone() => TimeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeRequest copyWith(void Function(TimeRequest) updates) => super.copyWith((message) => updates(message as TimeRequest)) as TimeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeRequest create() => TimeRequest._();
  TimeRequest createEmptyInstance() => create();
  static $pb.PbList<TimeRequest> createRepeated() => $pb.PbList<TimeRequest>();
  @$core.pragma('dart2js:noInline')
  static TimeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeRequest>(create);
  static TimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
}

class ScoreResponse extends $pb.GeneratedMessage {
  factory ScoreResponse({
    $core.int? score1,
    $core.int? score2,
    $core.int? totalScore1,
    $core.int? totalScore2,
  }) {
    final $result = create();
    if (score1 != null) {
      $result.score1 = score1;
    }
    if (score2 != null) {
      $result.score2 = score2;
    }
    if (totalScore1 != null) {
      $result.totalScore1 = totalScore1;
    }
    if (totalScore2 != null) {
      $result.totalScore2 = totalScore2;
    }
    return $result;
  }
  ScoreResponse._() : super();
  factory ScoreResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScoreResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScoreResponse', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'score1', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'score2', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalScore1', $pb.PbFieldType.O3, protoName: 'totalScore1')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalScore2', $pb.PbFieldType.O3, protoName: 'totalScore2')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScoreResponse clone() => ScoreResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScoreResponse copyWith(void Function(ScoreResponse) updates) => super.copyWith((message) => updates(message as ScoreResponse)) as ScoreResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScoreResponse create() => ScoreResponse._();
  ScoreResponse createEmptyInstance() => create();
  static $pb.PbList<ScoreResponse> createRepeated() => $pb.PbList<ScoreResponse>();
  @$core.pragma('dart2js:noInline')
  static ScoreResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScoreResponse>(create);
  static ScoreResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get score1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set score1($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScore1() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore1() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get score2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set score2($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScore2() => $_has(1);
  @$pb.TagNumber(2)
  void clearScore2() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalScore1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalScore1($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalScore1() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalScore1() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalScore2 => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalScore2($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalScore2() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalScore2() => clearField(4);
}

class EndRequest extends $pb.GeneratedMessage {
  factory EndRequest() => create();
  EndRequest._() : super();
  factory EndRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EndRequest', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndRequest clone() => EndRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndRequest copyWith(void Function(EndRequest) updates) => super.copyWith((message) => updates(message as EndRequest)) as EndRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndRequest create() => EndRequest._();
  EndRequest createEmptyInstance() => create();
  static $pb.PbList<EndRequest> createRepeated() => $pb.PbList<EndRequest>();
  @$core.pragma('dart2js:noInline')
  static EndRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndRequest>(create);
  static EndRequest? _defaultInstance;
}

class EndStatus extends $pb.GeneratedMessage {
  factory EndStatus({
    $core.String? status,
    $core.int? winner,
    $core.int? totalScore1,
    $core.int? totalScore2,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (winner != null) {
      $result.winner = winner;
    }
    if (totalScore1 != null) {
      $result.totalScore1 = totalScore1;
    }
    if (totalScore2 != null) {
      $result.totalScore2 = totalScore2;
    }
    return $result;
  }
  EndStatus._() : super();
  factory EndStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EndStatus', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'winner', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalScore1', $pb.PbFieldType.O3, protoName: 'totalScore1')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalScore2', $pb.PbFieldType.O3, protoName: 'totalScore2')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EndStatus clone() => EndStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EndStatus copyWith(void Function(EndStatus) updates) => super.copyWith((message) => updates(message as EndStatus)) as EndStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndStatus create() => EndStatus._();
  EndStatus createEmptyInstance() => create();
  static $pb.PbList<EndStatus> createRepeated() => $pb.PbList<EndStatus>();
  @$core.pragma('dart2js:noInline')
  static EndStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EndStatus>(create);
  static EndStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get winner => $_getIZ(1);
  @$pb.TagNumber(2)
  set winner($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWinner() => $_has(1);
  @$pb.TagNumber(2)
  void clearWinner() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalScore1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalScore1($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalScore1() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalScore1() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalScore2 => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalScore2($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalScore2() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalScore2() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
