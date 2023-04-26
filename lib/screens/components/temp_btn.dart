import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class TempBtn extends StatelessWidget {
  const TempBtn({
    super.key,
    required this.press,
    required this.title,
    required this.svgSrc,
    this.activeColor = primaryColor,
    this.isActive = false,
  });

  final String svgSrc, title;
  final bool isActive;
  final VoidCallback press;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOutBack,
            width: isActive ? 76 : 50,
            height: isActive ? 76 : 50,
            child: SvgPicture.asset(
              svgSrc,
              color: isActive ? activeColor : Colors.white38,
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          AnimatedDefaultTextStyle(
            child: Text(title.toUpperCase()),
            style: TextStyle(
                fontSize: 16,
                color: isActive ? activeColor : Colors.white38,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
