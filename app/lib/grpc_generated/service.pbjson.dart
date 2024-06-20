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

@$core.Deprecated('Use loadDataDescriptor instead')
const LoadData$json = {
  '1': 'LoadData',
};

/// Descriptor for `LoadData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadDataDescriptor = $convert.base64Decode(
    'CghMb2FkRGF0YQ==');

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
  ],
};

/// Descriptor for `GameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameRequestDescriptor = $convert.base64Decode(
    'CgtHYW1lUmVxdWVzdBIcCglzb25nVGl0bGUYASABKAlSCXNvbmdUaXRsZQ==');

@$core.Deprecated('Use gameStatusDescriptor instead')
const GameStatus$json = {
  '1': 'GameStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `GameStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStatusDescriptor = $convert.base64Decode(
    'CgpHYW1lU3RhdHVzEhYKBnN0YXR1cxgBIAEoCVIGc3RhdHVz');

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
    {'1': 'score', '3': 1, '4': 1, '5': 1, '10': 'score'},
    {'1': 'time', '3': 2, '4': 1, '5': 5, '10': 'time'},
  ],
};

/// Descriptor for `ScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreResponseDescriptor = $convert.base64Decode(
    'Cg1TY29yZVJlc3BvbnNlEhQKBXNjb3JlGAEgASgBUgVzY29yZRISCgR0aW1lGAIgASgFUgR0aW'
    '1l');

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
};

/// Descriptor for `EndStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endStatusDescriptor = $convert.base64Decode(
    'CglFbmRTdGF0dXM=');

