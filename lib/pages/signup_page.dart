import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xfff44336),
            Color(0xff2196f3),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.bubbles,
        particles: 79,
        color: Color(0x4e0ce922),
        blur: 0.16,
        size: 0.1,
        speed: 0.75,
        offset: 0,
        blendMode: BlendMode.screen,
        particleType: ParticleType.atlas,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: -3.14,
      ),
    );
  }
}
