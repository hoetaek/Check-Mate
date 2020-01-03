import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int dotsCount;
  final double pageIndex;
  final Color activeColor;
  final Color inactiveColor;

  const DotIndicator(
      {Key key,
      this.dotsCount,
      this.pageIndex,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          dotsCount + dotsCount - 1,
          (i) => i % 2 == 0
              ? AnimatedDot(
                  dotIndex: i,
                  activated: i == pageIndex * 2,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                )
              : SizedBox(width: 10),
        ),
      ),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  final int dotIndex;
  final bool activated;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedDot(
      {Key key,
      this.dotIndex,
      this.activated,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: activated ? activeColor : inactiveColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
