import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HoverWidget extends StatefulWidget {
  final Widget child;
  final Widget hoverChild;
  final void Function(PointerEnterEvent event) onHover;
  const HoverWidget({
    required this.child,
    required this.hoverChild,
    required this.onHover,
    Key? key,
  }) : super(key: key);

  @override
  HoverWidgetState createState() => HoverWidgetState();
}

class HoverWidgetState extends State<HoverWidget> {
  bool _isHover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHover = true;
        });
        widget.onHover(event);
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      child: _isHover ? widget.hoverChild : widget.child,
    );
  }
}
