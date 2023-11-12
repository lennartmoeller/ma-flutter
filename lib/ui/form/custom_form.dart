import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';

class CustomForm extends StatefulWidget {
  final Widget Function() formBuilder;

  const CustomForm({super.key, required this.formBuilder});

  @override
  CustomFormState createState() => CustomFormState();
}

class CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, FormInput> _formInputs = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.formBuilder(),
    );
  }

  bool get isValid => _formKey.currentState!.validate();

  Map<String, dynamic> get inputValues => Map<String, dynamic>.from(
        _formInputs.map((key, controller) => MapEntry(key, controller.value)),
      );

  void addFormInput(String id, FormInput formInput) => _formInputs[id] = formInput;
}
