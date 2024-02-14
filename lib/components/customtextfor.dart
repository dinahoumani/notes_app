import 'package:flutter/material.dart';

class CustTextForm extends StatelessWidget {
  final String? Function(String?)? valid;
  final String? hint;
  final TextEditingController myController;
  CustTextForm(this.valid, this.hint, this.myController, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        controller: myController,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
