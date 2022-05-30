import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldSideBorder extends StatelessWidget {
  const TextFieldSideBorder(
      {Key key,
      @required TextEditingController tfieldController,
      @required FocusNode focus,
      @required String hint,
      @required TextInputType keyboardType,
      bool obscureText = false,
      bool enabled = true,
      this.icon})
      : _tfieldController = tfieldController,
        _focus = focus,
        _hint = hint,
        _keyboardType = keyboardType,
        _obscureText = obscureText,
        _enabled = enabled,
        super(key: key);

  final TextEditingController _tfieldController;
  final FocusNode _focus;
  final String _hint;
  final bool _obscureText;
  final bool _enabled;
  final TextInputType _keyboardType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 10.0,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                    color: Color(0xffb1b1b1), //_focus.hasFocus ? Colors.blue :

                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  bottom: BorderSide(
                    color: Color(0xffb1b1b1), //_focus.hasFocus ? Colors.blue :
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: Color(0xffb1b1b1), //_focus.hasFocus ? Colors.blue :
                    width: 1.0,
                    style: BorderStyle.solid,
                  ))),
        ),
        TextFormField(
          obscureText: _obscureText,
          keyboardType: _keyboardType,
          controller: _tfieldController,
          focusNode: _focus,
          onTap: () {
            _focus.requestFocus();
          },
          enabled: _enabled,
          autofocus: false,
          onFieldSubmitted: (string) {
            _focus.unfocus();
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              ),
              labelStyle: GoogleFonts.montserrat(color: Color(0xffb1b1b1)),
              hintStyle: GoogleFonts.montserrat(color: Color(0xffb1b1b1)),
              hintText: _hint,
              suffixIcon: Icon(
                icon,
                color: Colors.grey,
              )),
        )
      ]),
    );
  }
}
