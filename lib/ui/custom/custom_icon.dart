import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/name_icon_mapping.dart';

enum Style { brands, light, regular, solid, thin, sharpLight, sharpRegular, sharpSolid }

class CustomIcon extends StatelessWidget {
  final String? name;
  final Style style;
  final double size;
  final double opacity;
  final Color? color;

  CustomIcon({
    super.key,
    this.name,
    this.style = Style.solid,
    this.size = 20.0,
    this.opacity = 1.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    String key = "${_getStringStyle(style)} ${name ?? "question"}";
    return Opacity(
      opacity: opacity,
      child: Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        child: OverflowBox(
          alignment: Alignment.center,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FaIcon(
            faIconNameMapping[key],
            size: size,
            color: color,
          ),
        ),
      ),
    );
  }

  String _getStringStyle(Style style) {
    switch (style) {
      case Style.brands:
        return 'brands';
      case Style.light:
        return 'light';
      case Style.regular:
        return 'regular';
      case Style.solid:
        return 'solid';
      case Style.thin:
        return 'thin';
      case Style.sharpLight:
        return 'sharp-light';
      case Style.sharpRegular:
        return 'sharp-regular';
      case Style.sharpSolid:
        return 'sharp-solid';
    }
  }
}
