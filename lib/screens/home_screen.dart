import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constants.dart';
import 'package:tesla_animated_app/home_controller.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/temp_btn.dart';
import 'components/temp_details.dart';
import 'components/tesla_bottom_navigationbar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _animationCarShift = CurvedAnimation(
        parent: _tempAnimationController, curve: Interval(0.2, 0.4));

    _animationTempShowInfo = CurvedAnimation(
        parent: _tempAnimationController, curve: Interval(0.45, 0.65));
  }

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      // Here the animation end on 0.5
      // it ends on 300 miliseconds
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      // After a delay we start this animation
      // after 60 milliseconds delay it start
      // so it start at 360 end on 600 milliseconds
      curve: Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // It rebuild the widget tree when any changes happend on our controller
      // This animation need listenable
      animation: Listenable.merge(
          [_controller, _batteryAnimationController, _tempAnimationController]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1)
                _batteryAnimationController.forward();
              else if (_controller.selectedBottomTab == 1 && index != 1)
                _batteryAnimationController.reverse(from: 0.7);
              if (index == 2)
                _tempAnimationController.forward();
              else if (_controller.selectedBottomTab == 2 && index != 2)
                _tempAnimationController.reverse(from: 0.4);
              _controller.onBottomNavigationTabChange(index);
            },
            selectedTab: _controller.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constrains) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: constrains.maxWidth,
                      height: constrains.maxHeight,
                    ),

                    Positioned(
                      left: constrains.maxWidth / 2 * _animationCarShift.value,
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: constrains.maxHeight * 0.1,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Car.svg",
                          width: double.infinity,
                        ),
                      ),
                    ),

                    //Door Locks
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.13
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.17
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),
                    // Battery
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        "assets/icons/Battery.svg",
                        width: constrains.maxWidth * 0.45,
                      ),
                    ),
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(constrains: constrains),
                      ),
                    ),
                    // Temp
                    Positioned(
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      top: 60 * (1 - _animationTempShowInfo.value),
                      child: Opacity(
                        opacity: _animationTempShowInfo.value,
                        child: TempDetails(
                          controller: _controller,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   right: 0,
                    //   child: Image.asset(
                    //     "assets/images/Cool_glow_2.png",
                    //     width: 200,
                    //   ),
                    // ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
