import 'package:flutter/material.dart';

enum ShadowType { NONE, LARGE, SMALL }

class MyContainer extends StatefulWidget {
  final ShadowType shadowType;
  Color color;
  final double radius;
  final Widget child;
  final bool ripple;
  final Function onTap;
  bool isHoverable;

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
    this.isHoverable = false,
  });

  @override
  State<StatefulWidget> createState() => _MyContainer();
}

class _MyContainer extends State<MyContainer> {
  double saturation;
  bool canChange = true;

  @override
  Widget build(BuildContext context) {
    // *Ripple effect
    // http://stacksecrets.com/flutter/adding-inkwell-splash-ripple-effect-to-custom-widgets-in-flutter
    return MouseRegion(
      onHover: (e) => {
        if(canChange && widget.isHoverable) {
          canChange = false,
          saturation = HSVColor.fromColor(widget.color).saturation,

          setState(() {
            widget.color = HSVColor.fromColor(widget.color).withSaturation(1 - saturation).toColor();
          }),
        },
      },    

      onExit: (e) => {
        if(widget.isHoverable){
          canChange = true,
          saturation = HSVColor.fromColor(widget.color).saturation, 
          
          setState(() {
            widget.color = HSVColor.fromColor(widget.color).withSaturation(1 - saturation).toColor();
          }),                
        }
      },

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
      color: widget.color != null ? widget.color : Colors.white,
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

