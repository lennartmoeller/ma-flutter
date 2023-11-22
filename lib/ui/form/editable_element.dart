import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/ui/util/row_with_separator.dart';

class EditableElement extends StatefulWidget {
  static const double maxDialogContainerWidth = 560.0;

  final Widget Function(BuildContext, void Function()) closedBuilder;
  final String dialogTitle;
  final Widget Function() formBuilder;
  final GlobalKey<CustomFormState> formKey;
  final Future<bool> Function(Map<String, dynamic> values)? onSave;
  final bool Function(Map<String, dynamic> values)? onClose;
  final double? closedBorderRadius;
  final double? closedElevation;
  final Color? closedColor;

  const EditableElement({
    required this.closedBuilder,
    required this.dialogTitle,
    required this.formBuilder,
    required this.formKey,
    this.onSave,
    this.onClose,
    this.closedBorderRadius,
    this.closedElevation,
    this.closedColor,
  });

  @override
  State<EditableElement> createState() => _EditableElementState();
}

class _EditableElementState extends State<EditableElement> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < EditableElement.maxDialogContainerWidth) {
      return _buildForThinDevices();
    } else {
      return _buildForWideDevices();
    }
  }

  Widget _buildForThinDevices() {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      closedElevation: widget.closedElevation ?? 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(widget.closedBorderRadius ?? 0)),
      ),
      closedColor: widget.closedColor ?? SkeletonState.colorScheme.surface,
      closedBuilder: widget.closedBuilder,
      openBuilder: (context, action) => _getThinDeviceDialogContent(),
    );
  }

  Widget _buildForWideDevices() {
    return Material(
      elevation: widget.closedElevation ?? 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.closedBorderRadius ?? 0)),
          color: widget.closedColor ?? SkeletonState.colorScheme.surface,
        ),
        child: widget.closedBuilder(context, () {
          var animationController = AnimationController(
            duration: const Duration(milliseconds: 200),
            vsync: Navigator.of(context),
          );
          animationController.forward();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: Curves.linear,
                ).drive(Tween(begin: 0.0, end: 1.0)),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeOut,
                  ).drive(Tween(begin: 0.9, end: 1.0)),
                  child: Dialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _getWideDeviceDialogContent(),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _getThinDeviceDialogContent() {
    return Container(
      color: SkeletonState.colorScheme.surface,
      padding: EdgeInsets.only(top: SkeletonState.statusBarHeight),
      child: Column(
        children: [
          Container(
            height: 56.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: RowWithSeparator(
              separator: SizedBox(width: 8.0),
              children: [
                IconButton(
                  onPressed: () => _onCloseButtonClick(),
                  icon: CustomIcon(
                    name: "xmark",
                    style: Style.regular,
                    size: 22.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.dialogTitle,
                    style: SkeletonState.textTheme.titleMedium,
                    maxLines: 1,
                  ),
                ),
                TextButton(
                  onPressed: () => _onSaveButtonClick(),
                  child: Text("Speichern"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: widget.formBuilder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWideDeviceDialogContent() {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      constraints: BoxConstraints(maxWidth: EditableElement.maxDialogContainerWidth),
      padding: EdgeInsets.only(top: statusBarHeight + 24.0, left: 24.0, right: 24.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.dialogTitle,
            style: SkeletonState.textTheme.titleLarge,
            maxLines: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: widget.formBuilder(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _onCloseButtonClick(),
                  child: Text("Verwerfen"),
                ),
                TextButton(
                  onPressed: () => _onSaveButtonClick(),
                  child: Text("Speichern"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSaveButtonClick() {
    if (!widget.formKey.currentState!.isValid) {
      return; // error in form input element
    }
    Map<String, dynamic> inputValues = widget.formKey.currentState!.inputValues;
    if (widget.onSave == null) {
      Navigator.pop(context);
    } else {
      widget.onSave!(inputValues).then((value) => Navigator.pop(context));
    }
  }

  void _onCloseButtonClick() {
    Map<String, dynamic> inputValues = widget.formKey.currentState!.inputValues;
    if (widget.onClose == null || widget.onClose!(inputValues)) {
      Navigator.pop(context);
    }
  }
}
