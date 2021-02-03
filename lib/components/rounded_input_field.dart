import 'package:BabyBeamApp/components/text_field_container.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color color, iconColor;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.color = greenBackGroundColor,
    this.iconColor = greenButtonColor,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, color: iconColor),
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Medium'),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
