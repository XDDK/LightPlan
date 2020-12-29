import 'package:flutter/material.dart';

enum ShadowType { NONE, LARGE, SMALL }

class MyContainer extends StatefulWidget {
  final ShadowType shadowType;
  final Color color;
  final double radius;
  final Widget child;
  final bool ripple;
  final Function onTap;

  final bool colorEffect;

  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;

  MyContainer({
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.shadowType = ShadowType.NONE,
    this.color = Colors.white,
    this.radius = 20,
    this.child,
    this.onTap,
    this.ripple = false,
    this.colorEffect = false,
  });

  @override
  State<StatefulWidget> createState() => _MyContainer();
}

class _MyContainer extends State<MyContainer> {
  Color finalColor;

  @override
  void initState() {
    super.initState();
    finalColor = widget.color;
  }

  // Change color on hover - singleton
  changeColor() {
    if (widget.colorEffect &&
        finalColor != null &&
        finalColor == widget.color) {
      double saturation = 1 - HSVColor.fromColor(widget.color).saturation;
      setState(() {
        finalColor = HSVColor.fromColor(widget.color)
            .withSaturation(saturation)
            .toColor();
      });
    }
  }

  // Change color back on hover exit
  resetColor() {
    if (widget.colorEffect) {
      setState(() {
        this.finalColor = widget.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // *Ripple effect
    // http://stacksecrets.com/flutter/adding-inkwell-splash-ripple-effect-to-custom-widgets-in-flutter
    return MouseRegion(
      onHover: (e) => changeColor(),
      onExit: (e) => resetColor(),
      child: Container(
        width: widget.width,
        height: widget.height,
        child: _buildChild,
        margin: widget.margin,
        decoration: _getBoxDecoration,
      ),
    );
  }

  BoxDecoration get _getBoxDecoration {
    return BoxDecoration(
      color: finalColor != null ? finalColor : Colors.transparent,
      borderRadius: BorderRadius.circular(widget.radius),
      boxShadow: _getShadow,
    );
  }

  Widget get _buildChild {
    if (widget.ripple) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: widget.onTap,
          child: _containerChild,
        ),
      );
    }

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: _containerChild,
      );
    }

    return _containerChild;
  }

  Widget get _containerChild {
    return Padding(
      padding: widget.padding,
      child: widget.child,
    );
  }

  List<BoxShadow> get _getShadow {
    double blurRadius;
    Offset offset;

    switch (widget.shadowType) {
      case ShadowType.NONE:
        return [];
      case ShadowType.LARGE:
        blurRadius = 4;
        offset = Offset(0, 4);
        break;
      case ShadowType.SMALL:
        blurRadius = 3;
        offset = Offset(0, 1);
        break;
      default:
        blurRadius = 4;
        offset = Offset(0, 4);
    }

    return [
      BoxShadow(
        blurRadius: blurRadius,
        offset: offset,
        color: Color.fromARGB(100, 0, 0, 0),
      )
    ];
  }
}
