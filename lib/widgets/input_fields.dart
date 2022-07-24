import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_secure/constants/colors.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.percentOfWidth,
    required this.controller,
    required this.label,
    required this.validator,
    this.suffixButton = false,
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController controller;
  final num percentOfWidth;
  final bool suffixButton;
  final String label;
  final String? Function(String?) validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (percentOfWidth / 100),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6)
        ],
        validator: validator,
        autofocus: true,
        textInputAction: TextInputAction.next,
        enableInteractiveSelection: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        readOnly: !enabled,
        decoration: InputDecoration(
            suffixIcon: suffixButton
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_circle_right_outlined))
                : null,
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            labelText: label,
            labelStyle: TextStyle(color: AppColors.themeColor),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: AppColors.themeColor as Color),
              // borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: AppColors.themeColor as Color),
              // borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
