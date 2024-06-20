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

class LoadData extends $pb.GeneratedMessage {
  factory LoadData() => create();
  LoadData._() : super();
  factory LoadData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoadData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoadData', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoadData clone() => LoadData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoadData copyWith(void Function(LoadData) updates) => super.copyWith((message) => updates(message as LoadData)) as LoadData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadData create() => LoadData._();
  LoadData createEmptyInstance() => create();
  static $pb.PbList<LoadData> createRepeated() => $pb.PbList<LoadData>();
  @$core.pragma('dart2js:noInline')
  static LoadData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoadData>(create);
  static LoadData? _defaultInstance;
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
  }) {
    final $result = create();
    if (songTitle != null) {
      $result.songTitle = songTitle;
    }
    return $result;
  }
  GameRequest._() : super();
  factory GameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'songTitle', protoName: 'songTitle')
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
}

class GameStatus extends $pb.GeneratedMessage {
  factory GameStatus({
    $core.String? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  GameStatus._() : super();
  factory GameStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameStatus', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
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
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
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
    $core.double? score,
    $core.int? time,
  }) {
    final $result = create();
    if (score != null) {
      $result.score = score;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  ScoreResponse._() : super();
  factory ScoreResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScoreResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScoreResponse', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OD)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'time', $pb.PbFieldType.O3)
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
  $core.double get score => $_getN(0);
  @$pb.TagNumber(1)
  set score($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get time => $_getIZ(1);
  @$pb.TagNumber(2)
  set time($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
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
  factory EndStatus() => create();
  EndStatus._() : super();
  factory EndStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EndStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EndStatus', createEmptyInstance: create)
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
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
