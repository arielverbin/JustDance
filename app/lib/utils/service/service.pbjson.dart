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
const loadData$json = {
  '1': 'loadData',
};

/// Descriptor for `loadData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadDataDescriptor = $convert.base64Decode(
    'Cghsb2FkRGF0YQ==');

@$core.Deprecated('Use loadStatusDescriptor instead')
const loadStatus$json = {
  '1': 'loadStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `loadStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadStatusDescriptor = $convert.base64Decode(
    'Cgpsb2FkU3RhdHVzEhYKBnN0YXR1cxgBIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'filename', '3': 1, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'width', '3': 3, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIaCghmaWxlbmFtZRgBIAEoCVIIZmlsZW5hbWUSFgoGZm9ybWF0GAIgASgJUgZmb3'
    'JtYXQSFAoFd2lkdGgYAyABKAVSBXdpZHRoEhYKBmhlaWdodBgEIAEoBVIGaGVpZ2h0EhIKBGRh'
    'dGEYBSABKAxSBGRhdGE=');

@$core.Deprecated('Use imageRequestDescriptor instead')
const ImageRequest$json = {
  '1': 'ImageRequest',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.Image', '10': 'image'},
    {'1': 'time', '3': 2, '4': 1, '5': 5, '10': 'time'},
  ],
};

/// Descriptor for `ImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageRequestDescriptor = $convert.base64Decode(
    'CgxJbWFnZVJlcXVlc3QSHAoFaW1hZ2UYASABKAsyBi5JbWFnZVIFaW1hZ2USEgoEdGltZRgCIA'
    'EoBVIEdGltZQ==');

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

