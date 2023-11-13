import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma_flutter/ui/form/inputs/text_based_form_input.dart';
import 'package:ma_flutter/util/euro.dart';

class EuroFormInput extends TextBasedFormInput {
  EuroFormInput({
    required super.formKey,
    required super.id,
    required super.label,
    int initial = 0,
    bool required = false,
    bool signed = true,
    String? Function(String?)? validator,
    void Function(int)? onSaved,
    super.iconName = "euro-sign",
  }) : super(
          validator: (String? value) {
            var output = validator?.call(value);
            if (output != null) {
              return output;
            }
            int? cents = Euro.toCent(value ?? '');
            if (cents == null) {
              return "Bitte gib einen validen Geldbetrag ein";
            }
            if (required && cents == 0) {
              return "Dieses Feld ist erforderlich";
            }
            return null;
          },
          onSaved: (String? str) {
            if (onSaved != null) {
              onSaved(Euro.toCent(str ?? '') ?? 0);
            }
          },
          keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: true),
          controller: TextEditingController(
              text: Euro.toStr(initial, includeEuroSign: false, includeDots: false)),
          inputFormatters: [EuroFormatter(signed: signed)],
        );

  @override
  int get value => Euro.toCent(controller!.text) ?? 0;
}

class EuroFormatter extends TextInputFormatter {
  bool signed;
  EuroFormatter({this.signed = true});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // allow empty input as starting point
    if (newValue.text.isEmpty) return newValue;
    // clean string
    String newText = newValue.text
        // allow points as commas
        .replaceAll('.', ',')
        // disallow all characters except digits, commas, minus
        .replaceAll(RegExp(r'[^0-9,-]'), '');
    // remove minus signs
    if (signed) {
      newText = newText.substring(0, 1) + newText.substring(1).replaceAll('-', '');
    } else {
      newText = newText.replaceAll('-', '');
    }
    // restore old value if the string is not a valid euro string
    RegExp regex = RegExp(r'^-?(0|[1-9][0-9]*)(,[0-9]{0,2})?$|^-$');
    if (!regex.hasMatch(newText)) return oldValue;
    // update value and ensure the cursor position is correct
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end > newText.length ? newText.length : newValue.selection.end,
      ),
    );
  }
}
