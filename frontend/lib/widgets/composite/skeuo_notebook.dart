import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../utils/haptics_helper.dart';

/// A realistic leather-bound notebook with stitched gold edges,
/// brass corner brackets, paper texture, and an animated page-turn interaction.
class SkeuoNotebook extends StatefulWidget {
  const SkeuoNotebook({super.key});

  @override
  State<SkeuoNotebook> createState() => _SkeuoNotebookState();
}

class _SkeuoNotebookState extends State<SkeuoNotebook>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOpen() {
    HapticsHelper.mediumImpact();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOpen,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final double flipVal = _flipAnimation.value;
              final bool showInside = flipVal > 0.5;

              return Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(flipVal * math.pi),
                child: showInside
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _buildInsidePage(),
                      )
                    : _buildCover(),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOpen ? Icons.menu_book_rounded : Icons.book_rounded,
                size: 14,
                color: const Color(0xFF6E4D2B),
              ),
              const SizedBox(width: 6),
              Text(
                _isOpen ? 'TAP TO CLOSE JOURNAL' : 'TAP TO OPEN JOURNAL',
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF6E4D2B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // Rich dark saddle leather gradient
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3F2A1C),
            Color(0xFF281A11),
            Color(0xFF1E130C),
            Color(0xFF150D08),
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
        ),
        border: Border.all(color: const Color(0xFF4D3322), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xDD000000),
            offset: Offset(3, 7),
            blurRadius: 14,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Stitched edge lines around perimeter
          Positioned.fill(
            child: CustomPaint(
              painter: _LeatherStitchPainter(),
            ),
          ),

          // Brass Corner Brackets
          const Positioned(top: 0, left: 0, child: _BrassCorner(isTop: true, isLeft: true)),
          const Positioned(top: 0, right: 0, child: _BrassCorner(isTop: true, isLeft: false)),
          const Positioned(bottom: 0, left: 0, child: _BrassCorner(isTop: false, isLeft: true)),
          const Positioned(bottom: 0, right: 0, child: _BrassCorner(isTop: false, isLeft: false)),

          // Brass Ribbon Bookmark emerging from top
          Positioned(
            top: 0,
            right: 36,
            child: Container(
              width: 14,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF8C1D1D),
                    Color(0xFFD32F2F),
                    Color(0xFF8C1D1D),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x88000000),
                    offset: Offset(1, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),

          // Embossed Gold Title Plaque in center
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: SkeuoColors.brassMid.withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DESIGN NOTES',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.0,
                      color: const Color(0xFFD4AA55),
                      shadows: [
                        const Shadow(
                          color: Color(0xDD000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 2.0,
                        ),
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.3),
                          offset: const Offset(0, -0.8),
                          blurRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 1.5,
                    color: const Color(0xFFB58832),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsidePage() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        // Aged ivory parchment ledger paper
        color: const Color(0xFFFAF6EB),
        border: Border.all(color: const Color(0xFFD8CFBD), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xCC000000),
            offset: Offset(4, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ruled Ledger Lines
          Positioned.fill(
            child: CustomPaint(
              painter: _RuledPaperPainter(),
            ),
          ),

          // Left binding crease shadow
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 18,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x55000000),
                    Color(0x22000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Handwritten Note Content
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 22, right: 20, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'VOL. 1 • FOUNDATIONS',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        color: Color(0xFF8C2D19),
                      ),
                    ),
                    Text(
                      'P. 42',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A6852),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  '“Real objects inspire digital interfaces.”',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF261D15),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Weight, bevels, texture, and light ground pixels in human intuition. A button is not just an outline; it is a spring-loaded object awaiting touch.',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A3B2C),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeatherStitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stitchPaint = Paint()
      ..color = const Color(0xFFD4AA55)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const offset = 8.0;
    const dashLength = 4.0;
    const dashSpace = 3.0;

    void drawDashedLine(Offset p1, Offset p2) {
      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      final ux = dx / dist;
      final uy = dy / dist;

      double current = 0.0;
      while (current < dist) {
        final end = math.min(current + dashLength, dist);
        canvas.drawLine(
          Offset(p1.dx + ux * current, p1.dy + uy * current),
          Offset(p1.dx + ux * end, p1.dy + uy * end),
          stitchPaint,
        );
        current += dashLength + dashSpace;
      }
    }

    drawDashedLine(const Offset(offset, offset), Offset(size.width - offset, offset));
    drawDashedLine(Offset(size.width - offset, offset), Offset(size.width - offset, size.height - offset));
    drawDashedLine(Offset(size.width - offset, size.height - offset), Offset(offset, size.height - offset));
    drawDashedLine(Offset(offset, size.height - offset), const Offset(offset, offset));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RuledPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Red margin line on left
    final marginPaint = Paint()
      ..color = const Color(0x33D32F2F)
      ..strokeWidth = 1.0;
    canvas.drawLine(const Offset(28, 0), Offset(28, size.height), marginPaint);

    // Blue horizontal ledger lines
    final linePaint = Paint()
      ..color = const Color(0x221E88E5)
      ..strokeWidth = 0.8;

    for (double y = 28; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrassCorner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _BrassCorner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
        ),
        gradient: const LinearGradient(
          colors: [
            SkeuoColors.brassHighlight,
            SkeuoColors.brassLight,
            SkeuoColors.brassMid,
            SkeuoColors.brassDark,
          ],
        ),
      ),
    );
  }
}
