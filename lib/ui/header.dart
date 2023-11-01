import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  static const headerHeight = 100.0;

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;

  const Header({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all((headerHeight - 52.0) / 2),
        child: Row(
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: leading!,
              ),
            Expanded(
              child: SizedBox(
                height: 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) Text(title!, style: textTheme.titleLarge),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
                      ),
                  ],
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
