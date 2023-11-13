import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';

class IconFormInput extends FormInput {
  IconFormInput({
    required super.formKey,
    required super.id,
    required super.label,
    String? initial = "",
    super.iconName = "icons",
    String? Function(String?)? validator,
    super.onSaved,
    super.required = false,
  }) : super(
          controller: TextEditingController(text: initial),
          validator: (String? value) {
            var output = validator?.call(value);
            if (output != null) {
              return output;
            }
            return null;
          },
          inputFormatters: [IconFormatter()],
        );

  @override
  String get value => controller?.text ?? "";
}

class IconFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9-]'), '');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end > newText.length ? newText.length : newValue.selection.end,
      ),
    );
  }
}
