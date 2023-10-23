import 'package:animate_do/animate_do.dart';
import 'package:flutter/src/widgets/framework.dart';

enum QuipoAnimation {
  fadeInUp,
  zoomIn,
}

class MAnimation extends StatelessWidget {
  const MAnimation({Key? key, required this.animation, required this.child})
      : super(key: key);

  final QuipoAnimation animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (animation) {
      case QuipoAnimation.fadeInUp:
        return FadeInUp(child: child);
      case QuipoAnimation.zoomIn:
        return ZoomIn(child: child);
    }
  }
}
