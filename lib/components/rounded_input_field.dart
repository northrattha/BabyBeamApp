import 'package:BabyBeamApp/components/text_field_container.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatelessWidget {
  static TextEditingController controller = new TextEditingController();
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color color, iconColor;
  final String input;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person_rounded,
    this.onChanged,
    this.color = greenBackGroundColor,
    this.iconColor = greenButtonColor,
    this.keyboardType,
    this.input,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = input;
    return TextFieldContainer(
      color: color,
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        // controller: controller,
        controller: TextEditingController()..text = input,
        // onChanged: (text) => {},
        decoration: InputDecoration(
          // labelText: 'dd',
          icon: Icon(icon, color: iconColor),
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Medium'),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
