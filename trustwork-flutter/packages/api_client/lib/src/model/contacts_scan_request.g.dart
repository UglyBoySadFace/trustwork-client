// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_scan_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactsScanRequest extends ContactsScanRequest {
  @override
  final BuiltList<String> phoneHashes;

  factory _$ContactsScanRequest(
          [void Function(ContactsScanRequestBuilder)? updates]) =>
      (ContactsScanRequestBuilder()..update(updates))._build();

  _$ContactsScanRequest._({required this.phoneHashes}) : super._();
  @override
  ContactsScanRequest rebuild(
          void Function(ContactsScanRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactsScanRequestBuilder toBuilder() =>
      ContactsScanRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactsScanRequest && phoneHashes == other.phoneHashes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneHashes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactsScanRequest')
          ..add('phoneHashes', phoneHashes))
        .toString();
  }
}

class ContactsScanRequestBuilder
    implements Builder<ContactsScanRequest, ContactsScanRequestBuilder> {
  _$ContactsScanRequest? _$v;

  ListBuilder<String>? _phoneHashes;
  ListBuilder<String> get phoneHashes =>
      _$this._phoneHashes ??= ListBuilder<String>();
  set phoneHashes(ListBuilder<String>? phoneHashes) =>
      _$this._phoneHashes = phoneHashes;

  ContactsScanRequestBuilder() {
    ContactsScanRequest._defaults(this);
  }

  ContactsScanRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneHashes = $v.phoneHashes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactsScanRequest other) {
    _$v = other as _$ContactsScanRequest;
  }

  @override
  void update(void Function(ContactsScanRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactsScanRequest build() => _build();

  _$ContactsScanRequest _build() {
    _$ContactsScanRequest _$result;
    try {
      _$result = _$v ??
          _$ContactsScanRequest._(
            phoneHashes: phoneHashes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'phoneHashes';
        phoneHashes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ContactsScanRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
