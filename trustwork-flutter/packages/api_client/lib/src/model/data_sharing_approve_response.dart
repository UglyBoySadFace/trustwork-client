//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'data_sharing_approve_response.g.dart';

/// DataSharingApproveResponse
///
/// Properties:
/// * [token] 
@BuiltValue()
abstract class DataSharingApproveResponse implements Built<DataSharingApproveResponse, DataSharingApproveResponseBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  DataSharingApproveResponse._();

  factory DataSharingApproveResponse([void updates(DataSharingApproveResponseBuilder b)]) = _$DataSharingApproveResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DataSharingApproveResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DataSharingApproveResponse> get serializer => _$DataSharingApproveResponseSerializer();
}

class _$DataSharingApproveResponseSerializer implements PrimitiveSerializer<DataSharingApproveResponse> {
  @override
  final Iterable<Type> types = const [DataSharingApproveResponse, _$DataSharingApproveResponse];

  @override
  final String wireName = r'DataSharingApproveResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DataSharingApproveResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DataSharingApproveResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DataSharingApproveResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DataSharingApproveResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DataSharingApproveResponseBuilder();
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

