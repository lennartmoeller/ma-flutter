import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/form/inputs/text_based_form_input.dart';

class TextFormInput extends TextBasedFormInput {
  TextFormInput({
    required super.formKey,
    required super.id,
    required super.label,
    String? initial = "",
    super.iconName = "tag",
    super.validator,
    super.onSaved,
    super.required = false,
  }) : super(controller: TextEditingController(text: initial));

  @override
  String get value => controller?.text ?? "";
}
