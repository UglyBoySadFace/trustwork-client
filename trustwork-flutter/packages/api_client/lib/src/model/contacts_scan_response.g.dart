// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_scan_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactsScanResponse extends ContactsScanResponse {
  @override
  final BuiltList<MatchedContact> matched;

  factory _$ContactsScanResponse(
          [void Function(ContactsScanResponseBuilder)? updates]) =>
      (ContactsScanResponseBuilder()..update(updates))._build();

  _$ContactsScanResponse._({required this.matched}) : super._();
  @override
  ContactsScanResponse rebuild(
          void Function(ContactsScanResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactsScanResponseBuilder toBuilder() =>
      ContactsScanResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactsScanResponse && matched == other.matched;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matched.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactsScanResponse')
          ..add('matched', matched))
        .toString();
  }
}

class ContactsScanResponseBuilder
    implements Builder<ContactsScanResponse, ContactsScanResponseBuilder> {
  _$ContactsScanResponse? _$v;

  ListBuilder<MatchedContact>? _matched;
  ListBuilder<MatchedContact> get matched =>
      _$this._matched ??= ListBuilder<MatchedContact>();
  set matched(ListBuilder<MatchedContact>? matched) =>
      _$this._matched = matched;

  ContactsScanResponseBuilder() {
    ContactsScanResponse._defaults(this);
  }

  ContactsScanResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matched = $v.matched.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactsScanResponse other) {
    _$v = other as _$ContactsScanResponse;
  }

  @override
  void update(void Function(ContactsScanResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactsScanResponse build() => _build();

  _$ContactsScanResponse _build() {
    _$ContactsScanResponse _$result;
    try {
      _$result = _$v ??
          _$ContactsScanResponse._(
            matched: matched.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'matched';
        matched.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ContactsScanResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
