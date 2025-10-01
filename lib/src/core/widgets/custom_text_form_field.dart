import 'package:flutter/material.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? label;
  final IconData? iconPath;
  //final bool obscureText;
  final bool? filled;
  final Color? fillColor;
  final String? errorText;
  final String? hintText;
  final Color? iconColor;
  bool isReadOnly = false;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? title;
  final String? Function(String?)? validator;

  final TextStyle? textStyle;
  final FontWeight fontWeight;
  final int maxLines;
  final TextInputType keyboardType;

  final Function(String)? onChanged;

  final InputBorder? border;

  CustomTextField({
    super.key,
    required this.textEditingController,
   // required this.obscureText,
    this.prefixIcon,
    this.isReadOnly = false,
    this.label,
    this.suffixIcon,
    this.iconPath,
    this.hintText,
    this.errorText,
    this.validator,
    this.title,
    this.textStyle,
    this.fontWeight = FontWeight.w400,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.filled,
    this.fillColor,
    this.border, 
    this.iconColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {


  @override
  void initState() {
    super.initState();
   // _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
    
      child: TextFormField(
        
        readOnly: widget.isReadOnly,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
       // obscureText: _isObscured,
        cursorHeight: 20,
        controller: widget.textEditingController,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          
          label: widget.label != null
              ? Text(
                  widget.label!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.white)
                )
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          //fillColor: widget.fillColor ?? ColorPalette.gray,
          //filled: widget.filled ?? true,
          prefixIcon: widget.prefixIcon ??
              (widget.iconPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(widget.iconPath,color:widget.iconColor ,)
                    )
                  : null),
          // suffixIcon: widget.obscureText
          //     ? IconButton(
                
          //         icon: Icon(
          //           Icons.import_contacts
          //          // _isObscured ? Iconsax.eye_slash : Iconsax.eye,
          //         ),
          //         onPressed: () {
          //           //! edit with cubit
          //           setState(() {
          //             _isObscured = !_isObscured;
          //           });
          //         },
          //       )
          //     : widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white),
          border: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.white, width: 1),
              ),
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.white,
                  width: 1,
                  ),
              ),
          focusedBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Colors.white,
                  width: 1),
              ),
          errorText: widget.errorText,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 10,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}