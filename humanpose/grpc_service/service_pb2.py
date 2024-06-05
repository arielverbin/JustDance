# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: service.proto
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database

# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()

DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(
    b'\n\rservice.proto\"\n\n\x08loadData\"\x1c\n\nloadStatus\x12\x0e\n\x06status\x18\x01 \x01('
    b'\t\"V\n\x05Image\x12\x10\n\x08\x66ilename\x18\x01 \x01(\t\x12\x0e\n\x06\x66ormat\x18\x02 \x01('
    b'\t\x12\r\n\x05width\x18\x03 \x01(\x05\x12\x0e\n\x06height\x18\x04 \x01(\x05\x12\x0c\n\x04\x64\x61ta\x18\x05 '
    b'\x01(\x0c\"3\n\x0cImageRequest\x12\x15\n\x05image\x18\x01 \x01(\x0b\x32\x06.Image\x12\x0c\n\x04time\x18\x02 '
    b'\x01(\x05\",\n\rScoreResponse\x12\r\n\x05score\x18\x01 \x01(\x01\x12\x0c\n\x04time\x18\x02 \x01('
    b'\x05\x32j\n\x12ScoringPoseService\x12\'\n\x0bloadService\x12\t.loadData\x1a\x0b.loadStatus\"\x00\x12+\n'
    b'\x08getScore\x12\r.ImageRequest\x1a\x0e.ScoreResponse\"\x00\x62\x06proto3')

_LOADDATA = DESCRIPTOR.message_types_by_name['loadData']
_LOADSTATUS = DESCRIPTOR.message_types_by_name['loadStatus']
_IMAGE = DESCRIPTOR.message_types_by_name['Image']
_IMAGEREQUEST = DESCRIPTOR.message_types_by_name['ImageRequest']
_SCORERESPONSE = DESCRIPTOR.message_types_by_name['ScoreResponse']
loadData = _reflection.GeneratedProtocolMessageType('loadData', (_message.Message,), {
    'DESCRIPTOR': _LOADDATA,
    '__module__': 'service_pb2'
    # @@protoc_insertion_point(class_scope:loadData)
})
_sym_db.RegisterMessage(loadData)

loadStatus = _reflection.GeneratedProtocolMessageType('loadStatus', (_message.Message,), {
    'DESCRIPTOR': _LOADSTATUS,
    '__module__': 'service_pb2'
    # @@protoc_insertion_point(class_scope:loadStatus)
})
_sym_db.RegisterMessage(loadStatus)

Image = _reflection.GeneratedProtocolMessageType('Image', (_message.Message,), {
    'DESCRIPTOR': _IMAGE,
    '__module__': 'service_pb2'
    # @@protoc_insertion_point(class_scope:Image)
})
_sym_db.RegisterMessage(Image)

ImageRequest = _reflection.GeneratedProtocolMessageType('ImageRequest', (_message.Message,), {
    'DESCRIPTOR': _IMAGEREQUEST,
    '__module__': 'service_pb2'
    # @@protoc_insertion_point(class_scope:ImageRequest)
})
_sym_db.RegisterMessage(ImageRequest)

ScoreResponse = _reflection.GeneratedProtocolMessageType('ScoreResponse', (_message.Message,), {
    'DESCRIPTOR': _SCORERESPONSE,
    '__module__': 'service_pb2'
    # @@protoc_insertion_point(class_scope:ScoreResponse)
})
_sym_db.RegisterMessage(ScoreResponse)

_SCORINGPOSESERVICE = DESCRIPTOR.services_by_name['ScoringPoseService']
if not _descriptor._USE_C_DESCRIPTORS:
    DESCRIPTOR._options = None
    _LOADDATA._serialized_start = 17
    _LOADDATA._serialized_end = 27
    _LOADSTATUS._serialized_start = 29
    _LOADSTATUS._serialized_end = 57
    _IMAGE._serialized_start = 59
    _IMAGE._serialized_end = 145
    _IMAGEREQUEST._serialized_start = 147
    _IMAGEREQUEST._serialized_end = 198
    _SCORERESPONSE._serialized_start = 200
    _SCORERESPONSE._serialized_end = 244
    _SCORINGPOSESERVICE._serialized_start = 246
    _SCORINGPOSESERVICE._serialized_end = 352
# @@protoc_insertion_point(module_scope)