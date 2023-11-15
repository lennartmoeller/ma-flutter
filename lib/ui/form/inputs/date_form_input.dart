import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/inputs/text_based_form_input.dart';
import 'package:ma_flutter/util/german_date.dart';

class DateFormInput extends StatefulWidget {
  final GlobalKey<CustomFormState> formKey;
  final String id;
  final String label;
  final String iconName;
  final GermanDate? initial;
  final bool required;
  final void Function(GermanDate?)? onSaved;

  const DateFormInput({
    super.key,
    required this.formKey,
    required this.id,
    required this.label,
    this.iconName = "calendar-days",
    this.initial,
    this.required = false,
    this.onSaved,
  });

  @override
  State<DateFormInput> createState() => _DateFormInputState();
}

class _DateFormInputState extends State<DateFormInput> {
  GermanDate? _value;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
    _controller.text = _value?.beautifyDate() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return _DateTextFormInput(
      formKey: widget.formKey,
      id: widget.id,
      label: widget.label,
      iconName: widget.iconName,
      required: widget.required,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _value?.toDateTime() ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(Duration(days: 365)),
          cancelText: "Verwerfen",
          confirmText: "Okay",
          helpText: "",
          locale: const Locale("de", "DE"),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
        );
        if (picked != null) {
          setState(() {
            _value = GermanDate(picked.toString());
            _controller.text = _value?.beautifyDate() ?? "";
          });
        }
      },
      readOnly: true,
      onSaved: (String? str) {
        if (widget.onSaved != null) {
          widget.onSaved!(str == null ? null : GermanDate(str));
        }
      },
      controller: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DateTextFormInput extends TextBasedFormInput {
  _DateTextFormInput({
    required super.formKey,
    required super.id,
    required super.label,
    String? initial = "",
    super.iconName = "calendar-days",
    super.onSaved,
    super.required = false,
    super.onTap,
    super.readOnly,
    TextEditingController? controller,
  }) : super(controller: controller ?? TextEditingController(text: initial));

  @override
  String? get value =>
      controller!.text.isEmpty ? null : controller!.text.split('.').reversed.join('-');
}
