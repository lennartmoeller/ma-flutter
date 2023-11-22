import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/editable_element.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';

class CreateElementFloatingActionButton extends StatelessWidget {
  final Widget Function() formBuilder;
  final GlobalKey<CustomFormState> formKey;
  final String dialogTitle;
  final Future<bool> Function(Map<String, dynamic>)? onSave;
  final bool Function(Map<String, dynamic>)? onClose;

  const CreateElementFloatingActionButton({
    super.key,
    required this.formBuilder,
    required this.formKey,
    required this.dialogTitle,
    this.onSave,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < EditableElement.maxDialogContainerWidth) {
      return EditableElement(
        // fab default border radius
        closedBorderRadius: 16.0,
        closedColor: SkeletonState.colorScheme.primaryContainer,
        // fab default background color
        closedElevation: 3,
        // fab default elevation
        closedBuilder: (context, action) => FloatingActionButton.extended(
          // remove elevation because elevation is set by EditableElement
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          onPressed: action,
          label: Text("Hinzufügen"),
          icon: CustomIcon(
            name: "plus",
            size: 16.0,
            style: Style.regular,
            color: SkeletonState.colorScheme.onPrimaryContainer,
          ),
        ),
        dialogTitle: dialogTitle,
        formBuilder: formBuilder,
        formKey: formKey,
        onSave: onSave,
        onClose: onClose,
      );
    } else {
      return Container();
    }
  }
}
