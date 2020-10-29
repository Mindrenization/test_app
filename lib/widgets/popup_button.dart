import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  PopupButton({this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          Container(
            width: 15,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
