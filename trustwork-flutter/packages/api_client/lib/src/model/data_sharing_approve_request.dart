//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/sharable_field.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'data_sharing_approve_request.g.dart';

/// DataSharingApproveRequest
///
/// Properties:
/// * [calleeMatrixId] 
/// * [approvedFields] 
@BuiltValue()
abstract class DataSharingApproveRequest implements Built<DataSharingApproveRequest, DataSharingApproveRequestBuilder> {
  @BuiltValueField(wireName: r'callee_matrix_id')
  String get calleeMatrixId;

  @BuiltValueField(wireName: r'approved_fields')
  BuiltList<SharableField> get approvedFields;

  DataSharingApproveRequest._();

  factory DataSharingApproveRequest([void updates(DataSharingApproveRequestBuilder b)]) = _$DataSharingApproveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DataSharingApproveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DataSharingApproveRequest> get serializer => _$DataSharingApproveRequestSerializer();
}

class _$DataSharingApproveRequestSerializer implements PrimitiveSerializer<DataSharingApproveRequest> {
  @override
  final Iterable<Type> types = const [DataSharingApproveRequest, _$DataSharingApproveRequest];

  @override
  final String wireName = r'DataSharingApproveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DataSharingApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'callee_matrix_id';
    yield serializers.serialize(
      object.calleeMatrixId,
      specifiedType: const FullType(String),
    );
    yield r'approved_fields';
    yield serializers.serialize(
      object.approvedFields,
      specifiedType: const FullType(BuiltList, [FullType(SharableField)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DataSharingApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DataSharingApproveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'callee_matrix_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calleeMatrixId = valueDes;
          break;
        case r'approved_fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SharableField)]),
          ) as BuiltList<SharableField>;
          result.approvedFields.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DataSharingApproveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DataSharingApproveRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

