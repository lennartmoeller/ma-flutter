import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/editable_element.dart';

class CreateElementTextButton extends StatelessWidget {
  final Widget form;
  final GlobalKey<CustomFormState> formKey;
  final String dialogTitle;
  final Future<bool> Function(Map<String, dynamic>)? onSave;
  final bool Function(Map<String, dynamic>)? onClose;

  const CreateElementTextButton({
    super.key,
    required this.form,
    required this.formKey,
    required this.dialogTitle,
    this.onSave,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return EditableElement(
      closedBuilder: (context, action) => TextButton.icon(
        onPressed: action,
        icon: CustomIcon(
          name: "plus",
          size: 14.0,
          style: Style.regular,
        ),
        label: Text("Hinzufügen"),
      ),
      dialogTitle: dialogTitle,
      form: form,
      formKey: formKey,
      onSave: onSave,
      onClose: onClose,
    );
  }
}
