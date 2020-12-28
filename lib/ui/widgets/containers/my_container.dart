import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ShadowType { NONE, LARGE, SMALL }

class MyContainer extends Container {
  final ShadowType shadowType;
  final Color color;
  final double radius;
  final Widget child;
  final bool ripple;
  final Function onTap;

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
  });

  @override
  Widget build(BuildContext context) {
    // *Ripple effect
    // http://stacksecrets.com/flutter/adding-inkwell-splash-ripple-effect-to-custom-widgets-in-flutter
    return MouseRegion(
      // TODO mouse hover lighten / darken container
      // onHover: () => print("mouse hover"),
      // onExit: () => print("mouse exit"),
      child: Container(
        width: this.width,
        height: this.height,
        child: _buildChild,
        margin: this.margin,
        decoration: _getBoxDecoration,
      ),
    );
  }

  BoxDecoration get _getBoxDecoration {
    return BoxDecoration(
      color: this.color != null ? this.color : Colors.white,
      borderRadius: BorderRadius.circular(this.radius),
      boxShadow: _getShadow,
    );
  }

  Widget get _buildChild {
    if (this.ripple && !kIsWeb) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(this.radius),
          onTap: this.onTap,
          child: _containerChild,
        ),
      );
    }
    if (this.onTap != null) {
      return GestureDetector(
        onTap: this.onTap,
        child: _containerChild,
      );
    }
    return _containerChild;
  }

  Widget get _containerChild {
    return Padding(
      padding: this.padding,
      child: this.child,
    );
  }

  List<BoxShadow> get _getShadow {
    double blurRadius;
    Offset offset;

    switch (this.shadowType) {
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
