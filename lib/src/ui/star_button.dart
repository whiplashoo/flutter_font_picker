// This code is from copied https://github.com/TeaTalkInternal/favorite_button to avoid
// adding another package dependency.
// Additionally this also allowed me to update/cleanup the original code, which has some
// lint issues with current flutter.
import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  StarButton({
    double? iconSize,
    Color? iconColor,
    bool? isStarred,
    Color? iconDisabledColor,
    required Function valueChanged,
    super.key,
  })  : _iconSize = iconSize ?? 60.0,
        _iconColor = iconColor ?? Colors.yellow,
        _iconDisabledColor = iconDisabledColor ?? Colors.grey[400],
        _isStarred = isStarred ?? false,
        _valueChanged = valueChanged;

  final double _iconSize;
  final Color _iconColor;
  final bool _isStarred;
  final Function _valueChanged;
  final Color? _iconDisabledColor;

  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  late CurvedAnimation _curve;

  double _maxIconSize = 0.0;
  double _minIconSize = 0.0;

  final int _animationTime = 400;

  bool _isStarred = false;
  bool _isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();

    _isStarred = widget._isStarred;
    _maxIconSize = (widget._iconSize < 20.0)
        ? 20.0
        : (widget._iconSize > 100.0)
            ? 100.0
            : widget._iconSize;
    final double sizeDifference = _maxIconSize * 0.30;
    _minIconSize = _maxIconSize - sizeDifference;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationTime),
    );

    _curve = CurvedAnimation(curve: Curves.slowMiddle, parent: _controller);

    _colorAnimation = ColorTween(
      begin: _isStarred ? widget._iconColor : widget._iconDisabledColor,
      end: _isStarred ? widget._iconDisabledColor : widget._iconColor,
    ).animate(_curve);

    _sizeAnimation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _minIconSize,
            end: _maxIconSize,
          ),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _maxIconSize,
            end: _minIconSize,
          ),
          weight: 50,
        ),
      ],
    ).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimationCompleted = true;
        _isStarred = !_isStarred;
        widget._valueChanged(_isStarred);
      } else if (status == AnimationStatus.dismissed) {
        _isAnimationCompleted = false;
        _isStarred = !_isStarred;
        widget._valueChanged(_isStarred);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("NEW _isFavorite $_isStarred");
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return InkResponse(
          onTap: () {
            setState(() {
              if (_isAnimationCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            });
          },
          child: Icon(
            (Icons.star),
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}
