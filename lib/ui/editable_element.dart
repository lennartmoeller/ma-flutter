import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/font_awesome_icon.dart';

class EditableElement extends StatelessWidget {
  static const double maxDialogContainerWidth = 560.0;

  final Widget Function(BuildContext, void Function()) closedBuilder;
  final String dialogTitle;
  final Widget dialogContent;
  final void Function()? onClose;
  final bool Function()? onSave;
  final double? closedBorderRadius;
  final double? closedElevation;
  final Color? closedColor;
  final Color? openedColor;

  const EditableElement({
    required this.closedBuilder,
    required this.dialogTitle,
    required this.dialogContent,
    this.onClose,
    this.onSave,
    this.closedBorderRadius,
    this.closedElevation,
    this.closedColor,
    this.openedColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < maxDialogContainerWidth) {
      return _buildForThinDevices(context);
    } else {
      return _buildForWideDevices(context);
    }
  }

  Widget _buildForThinDevices(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      closedElevation: closedElevation ?? 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(closedBorderRadius ?? 0))),
      closedColor: _getClosedColor(context),
      closedBuilder: closedBuilder,
      openBuilder: (context, action) => _getThinDeviceDialogContent(context),
    );
  }

  Widget _buildForWideDevices(BuildContext context) {
    return Material(
      elevation: closedElevation ?? 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(closedBorderRadius ?? 0)),
          color: _getClosedColor(context),
        ),
        child: closedBuilder(
          context,
          () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: _getWideDeviceDialogContent(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getThinDeviceDialogContent(BuildContext context) {
    return Container(
      color: _getOpenedColor(context),
      child: Column(
        children: [
          SizedBox(
            height: 56.0,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: IconButton(
                    onPressed: () => _closeDialog(context),
                    icon: FontAwesomeIcon(
                      name: "xmark",
                      style: Style.regular,
                      size: 22.0,
                    ),
                  ),
                ),
                Expanded(child: _getDialogTitle(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () => _saveElement(context),
                    child: Text("Speichern"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: dialogContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWideDeviceDialogContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxDialogContainerWidth),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getDialogTitle(context),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: dialogContent,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _closeDialog(context),
                    child: Text("Verwerfen"),
                  ),
                  TextButton(
                    onPressed: () => _saveElement(context),
                    child: Text("Speichern"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDialogTitle(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      dialogTitle,
      style: textTheme.titleLarge,
    );
  }

  Color _getOpenedColor(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return openedColor ?? colorScheme.surface;
  }

  Color _getClosedColor(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return closedColor ?? colorScheme.surface;
  }

  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void _saveElement(BuildContext context) {
    if (onSave == null || onSave!()) _closeDialog(context);
  }
}
