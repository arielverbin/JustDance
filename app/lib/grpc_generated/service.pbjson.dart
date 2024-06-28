//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use emptyMessageDescriptor instead')
const EmptyMessage$json = {
  '1': 'EmptyMessage',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `EmptyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyMessageDescriptor = $convert.base64Decode(
    'CgxFbXB0eU1lc3NhZ2USFgoGc3RhdHVzGAEgASgJUgZzdGF0dXM=');

@$core.Deprecated('Use loadStatusDescriptor instead')
const LoadStatus$json = {
  '1': 'LoadStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `LoadStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadStatusDescriptor = $convert.base64Decode(
    'CgpMb2FkU3RhdHVzEhYKBnN0YXR1cxgBIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use gameRequestDescriptor instead')
const GameRequest$json = {
  '1': 'GameRequest',
  '2': [
    {'1': 'songTitle', '3': 1, '4': 1, '5': 9, '10': 'songTitle'},
    {'1': 'numberOfPlayers', '3': 2, '4': 1, '5': 5, '10': 'numberOfPlayers'},
    {'1': 'gameSpeed', '3': 3, '4': 1, '5': 5, '10': 'gameSpeed'},
  ],
};

/// Descriptor for `GameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameRequestDescriptor = $convert.base64Decode(
    'CgtHYW1lUmVxdWVzdBIcCglzb25nVGl0bGUYASABKAlSCXNvbmdUaXRsZRIoCg9udW1iZXJPZl'
    'BsYXllcnMYAiABKAVSD251bWJlck9mUGxheWVycxIcCglnYW1lU3BlZWQYAyABKAVSCWdhbWVT'
    'cGVlZA==');

@$core.Deprecated('Use gameStatusDescriptor instead')
const GameStatus$json = {
  '1': 'GameStatus',
  '2': [
    {'1': 'numberOfPlayers', '3': 1, '4': 1, '5': 5, '10': 'numberOfPlayers'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `GameStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStatusDescriptor = $convert.base64Decode(
    'CgpHYW1lU3RhdHVzEigKD251bWJlck9mUGxheWVycxgBIAEoBVIPbnVtYmVyT2ZQbGF5ZXJzEh'
    'YKBnN0YXR1cxgCIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use timeRequestDescriptor instead')
const TimeRequest$json = {
  '1': 'TimeRequest',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 5, '10': 'time'},
  ],
};

/// Descriptor for `TimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeRequestDescriptor = $convert.base64Decode(
    'CgtUaW1lUmVxdWVzdBISCgR0aW1lGAEgASgFUgR0aW1l');

@$core.Deprecated('Use scoreResponseDescriptor instead')
const ScoreResponse$json = {
  '1': 'ScoreResponse',
  '2': [
    {'1': 'score1', '3': 1, '4': 1, '5': 5, '10': 'score1'},
    {'1': 'totalScore1', '3': 3, '4': 1, '5': 5, '10': 'totalScore1'},
    {'1': 'score2', '3': 2, '4': 1, '5': 5, '10': 'score2'},
    {'1': 'totalScore2', '3': 4, '4': 1, '5': 5, '10': 'totalScore2'},
  ],
};

/// Descriptor for `ScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreResponseDescriptor = $convert.base64Decode(
    'Cg1TY29yZVJlc3BvbnNlEhYKBnNjb3JlMRgBIAEoBVIGc2NvcmUxEiAKC3RvdGFsU2NvcmUxGA'
    'MgASgFUgt0b3RhbFNjb3JlMRIWCgZzY29yZTIYAiABKAVSBnNjb3JlMhIgCgt0b3RhbFNjb3Jl'
    'MhgEIAEoBVILdG90YWxTY29yZTI=');

@$core.Deprecated('Use endRequestDescriptor instead')
const EndRequest$json = {
  '1': 'EndRequest',
};

/// Descriptor for `EndRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endRequestDescriptor = $convert.base64Decode(
    'CgpFbmRSZXF1ZXN0');

@$core.Deprecated('Use endStatusDescriptor instead')
const EndStatus$json = {
  '1': 'EndStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {'1': 'winner', '3': 2, '4': 1, '5': 5, '10': 'winner'},
    {'1': 'totalScore1', '3': 3, '4': 1, '5': 5, '10': 'totalScore1'},
    {'1': 'totalScore2', '3': 4, '4': 1, '5': 5, '10': 'totalScore2'},
  ],
};

/// Descriptor for `EndStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endStatusDescriptor = $convert.base64Decode(
    'CglFbmRTdGF0dXMSFgoGc3RhdHVzGAEgASgJUgZzdGF0dXMSFgoGd2lubmVyGAIgASgFUgZ3aW'
    '5uZXISIAoLdG90YWxTY29yZTEYAyABKAVSC3RvdGFsU2NvcmUxEiAKC3RvdGFsU2NvcmUyGAQg'
    'ASgFUgt0b3RhbFNjb3JlMg==');

