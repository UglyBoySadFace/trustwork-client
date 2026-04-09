// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_check_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhoneCheckResponse extends PhoneCheckResponse {
  @override
  final String phone;
  @override
  final bool registered;

  factory _$PhoneCheckResponse(
          [void Function(PhoneCheckResponseBuilder)? updates]) =>
      (PhoneCheckResponseBuilder()..update(updates))._build();

  _$PhoneCheckResponse._({required this.phone, required this.registered})
      : super._();
  @override
  PhoneCheckResponse rebuild(
          void Function(PhoneCheckResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhoneCheckResponseBuilder toBuilder() =>
      PhoneCheckResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhoneCheckResponse &&
        phone == other.phone &&
        registered == other.registered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, registered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhoneCheckResponse')
          ..add('phone', phone)
          ..add('registered', registered))
        .toString();
  }
}

class PhoneCheckResponseBuilder
    implements Builder<PhoneCheckResponse, PhoneCheckResponseBuilder> {
  _$PhoneCheckResponse? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  bool? _registered;
  bool? get registered => _$this._registered;
  set registered(bool? registered) => _$this._registered = registered;

  PhoneCheckResponseBuilder() {
    PhoneCheckResponse._defaults(this);
  }

  PhoneCheckResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _registered = $v.registered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhoneCheckResponse other) {
    _$v = other as _$PhoneCheckResponse;
  }

  @override
  void update(void Function(PhoneCheckResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhoneCheckResponse build() => _build();

  _$PhoneCheckResponse _build() {
    final _$result = _$v ??
        _$PhoneCheckResponse._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'PhoneCheckResponse', 'phone'),
          registered: BuiltValueNullFieldError.checkNotNull(
              registered, r'PhoneCheckResponse', 'registered'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
