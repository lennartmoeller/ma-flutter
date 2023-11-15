import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';

abstract class TextBasedFormInput extends TextFormField implements FormInput {
  TextBasedFormInput({
    required GlobalKey<CustomFormState> formKey,
    required String id,
    required String label,
    required String iconName,
    bool required = false,
    String? Function(String?)? validator,
    super.onTap,
    super.readOnly,
    super.onSaved,
    super.keyboardType,
    super.controller,
    super.inputFormatters,
  }) : super(
          decoration: InputDecoration(
            labelText: label,
            icon: CustomIcon(name: iconName, style: Style.regular),
          ),
          validator: (String? value) {
            var output = validator?.call(value);
            if (output != null) {
              return output;
            }
            if (required && (value == null || value.isEmpty)) {
              return "Dieses Feld ist erforderlich";
            } else {
              return null;
            }
          },
        ) {
    formKey.currentState!.addFormInput(id, this);
  }
}
