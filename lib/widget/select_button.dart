import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomButton(
      {required this.text, required this.value, required this.onChanged});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.value; // initial value
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChanged(_isSelected);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150), // Duration to animate over
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          color: _isSelected ? Color(0xFF43BC69) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSelected) ...[
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
