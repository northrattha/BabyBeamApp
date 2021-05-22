import 'package:BabyBeamApp/components/text_field_container.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final Color color, iconColor;
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.color = greenBackGroundColor,
    this.iconColor = greenButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'รหัสผ่าน',
          hintStyle: TextStyle(fontFamily: 'Medium'),
          icon: Icon(Icons.lock, color: iconColor),
          // Show/Hide Password 
          suffixIcon: Icon(
            Icons.visibility,
            color: iconColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
