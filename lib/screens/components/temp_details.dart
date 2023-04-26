import 'package:flutter/material.dart';
import 'package:tesla_animated_app/screens/components/temp_btn.dart';

import '../../constants.dart';
import '../../home_controller.dart';

class TempDetails extends StatelessWidget {
  const TempDetails({
    super.key,
    required HomeController controller,
  }) : _controller = controller;

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                  title: "Cool",
                  svgSrc: "assets/icons/coolShape.svg",
                  press: _controller.updateCoolSelectedTab,
                  isActive: _controller.isCoolSelected,
                ),
                const SizedBox(width: defaultPadding),
                TempBtn(
                  title: "Heat",
                  svgSrc: "assets/icons/heatShape.svg",
                  activeColor: redColor,
                  press: _controller.updateCoolSelectedTab,
                  isActive: !_controller.isCoolSelected,
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_drop_up,
                  size: 48,
                ),
              ),
              Text("29" + "\u2103", style: TextStyle(fontSize: 86)),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_down, size: 48),
              ),
            ],
          ),
          Spacer(),
          Text("CURRENT TEMPERATURE"),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inside".toUpperCase()),
                  Text(
                    "20" + '\u2103',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Inside".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                  Text("35" + '\u2103',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white54)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
