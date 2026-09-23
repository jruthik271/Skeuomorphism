import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_gradients.dart';
import '../../utils/haptics_helper.dart';

enum ButtonType { industrialRed, machinedMetal, brass, illuminated }
enum SkeuoButtonSize { small, medium, large }

/// A realistic 3D mechanical push button with spring plunger stroke,
/// beveled housing collar, and dynamic highlight/shadow transitions.
class SkeuoButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double width;
  final double height;
  final IconData? icon;
  final bool isCircle;
  final TextStyle? textStyle;
  final SkeuoButtonSize? size;

  const SkeuoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.industrialRed,
    this.width = 110.0,
    this.height = 56.0,
    this.icon,
    this.isCircle = false,
    this.textStyle,
    this.size,
  });

  @override
  State<SkeuoButton> createState() => _SkeuoButtonState();
}

class _SkeuoButtonState extends State<SkeuoButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticsHelper.mediumImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    HapticsHelper.lightImpact();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double baseWidth = widget.size == SkeuoButtonSize.small
        ? 88.0
        : (widget.size == SkeuoButtonSize.large ? 170.0 : widget.width);
    final double baseHeight = widget.size == SkeuoButtonSize.small
        ? 36.0
        : (widget.size == SkeuoButtonSize.large ? 56.0 : widget.height);
    final double actualWidth = widget.isCircle ? baseHeight : baseWidth;
    final double actualHeight = baseHeight;
    final borderRadius = widget.isCircle
        ? BorderRadius.circular(actualHeight / 2)
        : BorderRadius.circular(10.0);

    // Color definitions based on type
    final Color buttonBaseColor;
    final Color buttonHighlight;
    final Color buttonShadow;
    final Color labelColor;

    switch (widget.type) {
      case ButtonType.industrialRed:
        buttonBaseColor = const Color(0xFFC72626);
        buttonHighlight = const Color(0xFFFF5252);
        buttonShadow = const Color(0xFF6E0D0D);
        labelColor = Colors.white;
        break;
      case ButtonType.machinedMetal:
        buttonBaseColor = SkeuoColors.metalMid;
        buttonHighlight = Colors.white;
        buttonShadow = const Color(0xFF555B63);
        labelColor = const Color(0xFF1E2125);
        break;
      case ButtonType.brass:
        buttonBaseColor = SkeuoColors.brassMid;
        buttonHighlight = SkeuoColors.brassHighlight;
        buttonShadow = SkeuoColors.brassShadow;
        labelColor = const Color(0xFF382305);
        break;
      case ButtonType.illuminated:
        buttonBaseColor = const Color(0xFF009688);
        buttonHighlight = const Color(0xFF4DB6AC);
        buttonShadow = const Color(0xFF004D40);
        labelColor = Colors.white;
        break;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: actualWidth + 12,
        height: actualHeight + 12,
        // Mounting collar bezel (fixed stationary base plate)
        decoration: BoxDecoration(
          borderRadius: borderRadius.add(BorderRadius.circular(4)),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C3035),
              Color(0xFF1B1E22),
              Color(0xFF141618),
              Color(0xFF262A2E),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
          border: Border.all(color: const Color(0xFF141618), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0xAA000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(5.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isPressed ? 3.5 : 0.0)
            ..scale(_isPressed ? 0.965 : 1.0),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: _isPressed
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      buttonShadow,
                      buttonBaseColor,
                    ],
                    stops: const [0.0, 1.0],
                  )
                : SkeuoGradients.pushButtonCap(
                    primaryColor: buttonBaseColor,
                    highlightColor: buttonHighlight,
                    shadowColor: buttonShadow,
                  ),
            border: Border.all(
              color: _isPressed ? buttonShadow : buttonHighlight.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: const Color(0x99000000),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xBB000000),
                      offset: const Offset(1, 4),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: buttonBaseColor.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: labelColor,
                    shadows: _isPressed
                        ? [
                            const Shadow(
                              color: Color(0x99000000),
                              offset: Offset(0, -1),
                              blurRadius: 1,
                            ),
                          ]
                        : [
                            const Shadow(
                              color: Color(0xAA000000),
                              offset: Offset(0, 1.5),
                              blurRadius: 2,
                            ),
                          ],
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    widget.label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.textStyle ??
                        TextStyle(
                          fontFamily: 'sans-serif',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.2,
                          color: labelColor,
                          shadows: _isPressed
                              ? [
                                  const Shadow(
                                    color: Color(0xBB000000),
                                    offset: Offset(0, -1.0),
                                    blurRadius: 1.0,
                                  ),
                                ]
                              : [
                                  const Shadow(
                                    color: Color(0xAA000000),
                                    offset: Offset(0, 1.5),
                                    blurRadius: 2.0,
                                  ),
                                  if (widget.type == ButtonType.machinedMetal)
                                    Shadow(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      offset: const Offset(0, -0.8),
                                      blurRadius: 0.5,
                                    ),
                                ],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
