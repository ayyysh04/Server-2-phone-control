import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final double height;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final Gradient? gradient;
  final BorderRadius? radius;
  final Function() onPressed;
  final BoxBorder? border;
  final EdgeInsets padding;
  final EdgeInsets margin;

  /// DialogButton constructor
  DialogButton({
    Key? key,
    required this.child,
    this.width,
    this.height = 40.0,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.gradient,
    this.radius,
    this.border,
    this.padding = const EdgeInsets.only(left: 6, right: 6),
    this.margin = const EdgeInsets.all(6),
    required this.onPressed,
  }) : super(key: key);

  /// Creates alert buttons based on constructor params
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.secondary,
          gradient: gradient,
          borderRadius: radius ?? BorderRadius.circular(6),
          border: border ?? Border.all(color: Colors.transparent, width: 0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: highlightColor ?? Theme.of(context).highlightColor,
          splashColor: splashColor ?? Theme.of(context).splashColor,
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
