import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  final void Function(String code) onCompleted;

  /// Pre-fills all boxes and fires [onCompleted] on the first frame.
  /// Pass a new value (via [ValueKey]) to replace the current input.
  final String? initialCode;

  const OtpInput({
    required this.onCompleted,
    this.initialCode,
    super.key,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  static const _length = 6;
  final _controllers =
      List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    final code = widget.initialCode;
    if (code != null && code.length == _length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fill(code));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _fill(String digits) {
    for (var i = 0; i < _length; i++) {
      _controllers[i].value = TextEditingValue(
        text: digits[i],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }
    _focusNodes.last.requestFocus();
    widget.onCompleted(digits);
  }

  void _onChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _controllers[index].clear();
      return;
    }

    if (digits.length > 1) {
      // Paste: distribute digits across boxes starting from this one.
      for (var i = 0; i < digits.length && index + i < _length; i++) {
        _controllers[index + i].value = TextEditingValue(
          text: digits[i],
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
      final lastFilled = (index + digits.length - 1).clamp(0, _length - 1);
      if (lastFilled < _length - 1) {
        _focusNodes[lastFilled + 1].requestFocus();
      } else {
        _focusNodes[lastFilled].unfocus();
      }
    } else {
      _controllers[index].value = TextEditingValue(
        text: digits,
        selection: const TextSelection.collapsed(offset: 1),
      );
      if (index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length == _length) {
      widget.onCompleted(code);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: List.generate(_length, (index) {
        return KeyboardListener(
          focusNode: FocusNode(skipTraversal: true),
          onKeyEvent: (event) => _onKeyEvent(index, event),
          child: SizedBox(
            width: 44,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 1,
              decoration: const InputDecoration(counterText: ''),
              onChanged: (value) => _onChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
