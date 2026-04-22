//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matrix_password_response.g.dart';

/// MatrixPasswordResponse
///
/// Properties:
/// * [matrixPassword] 
@BuiltValue()
abstract class MatrixPasswordResponse implements Built<MatrixPasswordResponse, MatrixPasswordResponseBuilder> {
  @BuiltValueField(wireName: r'matrix_password')
  String get matrixPassword;

  MatrixPasswordResponse._();

  factory MatrixPasswordResponse([void updates(MatrixPasswordResponseBuilder b)]) = _$MatrixPasswordResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatrixPasswordResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatrixPasswordResponse> get serializer => _$MatrixPasswordResponseSerializer();
}

class _$MatrixPasswordResponseSerializer implements PrimitiveSerializer<MatrixPasswordResponse> {
  @override
  final Iterable<Type> types = const [MatrixPasswordResponse, _$MatrixPasswordResponse];

  @override
  final String wireName = r'MatrixPasswordResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatrixPasswordResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matrix_password';
    yield serializers.serialize(
      object.matrixPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MatrixPasswordResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatrixPasswordResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matrix_password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matrixPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatrixPasswordResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatrixPasswordResponseBuilder();
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

