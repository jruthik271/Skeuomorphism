import 'package:flutter/material.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';

/// A vintage illuminated AM/FM radio frequency tuning dial with
/// warm incandescent backlight, red indicator cursor, and tuning wheel.
class RadioDial extends StatefulWidget {
  final double frequency; // 0.0 to 1.0 (maps to 88-108 MHz FM)
  final ValueChanged<double>? onTuned;

  const RadioDial({
    super.key,
    this.frequency = 0.45,
    this.onTuned,
  });

  @override
  State<RadioDial> createState() => _RadioDialState();
}

class _RadioDialState extends State<RadioDial> {
  late double _frequency;
  int _lastTick = -1;

  @override
  void initState() {
    super.initState();
    _frequency = widget.frequency.clamp(0.0, 1.0);
  }

  void _updateFrequency(double newFreq) {
    final clamped = newFreq.clamp(0.0, 1.0);
    if (clamped != _frequency) {
      setState(() {
        _frequency = clamped;
      });
      final tick = (clamped * 20).round();
      if (tick != _lastTick) {
        _lastTick = tick;
        HapticsHelper.lightImpact();
      }
      widget.onTuned?.call(_frequency);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate display frequency in FM (88 - 108 MHz)
    final fm = (88.0 + _frequency * 20.0).toStringAsFixed(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dial housing with warm incandescent backlight
        Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Bakelite / dark chassis rim
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF321F14),
                Color(0xFF1E130C),
                Color(0xFF140D08),
              ],
            ),
            border: Border.all(color: const Color(0xFF4A3222), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0xDD000000),
                offset: Offset(2, 4),
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // Warm incandescent amber dial glow
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF38230D),
                  Color(0xFF6B451B),
                  Color(0xFF4D3012),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              border: Border.all(color: const Color(0xFF120A05), width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  // Frequency scales
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // FM Scale (88 - 108 MHz)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('FM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFE8C88B))),
                              Text('88', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('92', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('96', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('100', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('104', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('108', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFE8C88B))),
                              Text('MHz', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFE8C88B))),
                            ],
                          ),

                          // Ticks lines in center
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomPaint(
                              painter: _RadioDialTicksPainter(),
                            ),
                          ),

                          // AM Scale (540 - 1600 kHz)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('AM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFD4A559))),
                              Text('54', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('70', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('90', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('120', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('140', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('160', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD4A559))),
                              Text('x10 kHz', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFD4A559))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Red frequency cursor needle
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final usableWidth = constraints.maxWidth - 32;
                        final cursorX = 16 + usableWidth * _frequency;

                        return Stack(
                          children: [
                            Positioned(
                              left: cursorX - 1.5,
                              top: 2,
                              bottom: 2,
                              child: Container(
                                width: 3.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF2222),
                                  borderRadius: BorderRadius.circular(1.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xAAFF2222),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: Color(0x99000000),
                                      offset: Offset(2, 0),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Glass reflection glare
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.8, -1.0),
                            end: Alignment(0.8, 1.0),
                            colors: [
                              Color(0x35FFFFFF),
                              Color(0x08FFFFFF),
                              Color(0x00FFFFFF),
                              Color(0x20FFFFFF),
                            ],
                            stops: [0.0, 0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Interactive Tuning Thumbwheel & Station readout
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            // Station Readout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF140D08),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF382312), width: 1.0),
              ),
              child: Text(
                'TUNED: $fm MHz',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFFB300),
                  shadows: [
                    Shadow(color: Color(0x88FFB300), blurRadius: 4),
                  ],
                ),
              ),
            ),

            // Horizontal Tuning Thumbwheel
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                _updateFrequency(_frequency + details.delta.dx * 0.005);
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  // Fluted knurled brass thumbwheel
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF4A320E),
                      Color(0xFFDFB660),
                      Color(0xFFFBE49D),
                      Color(0xFFDFB660),
                      Color(0xFF4A320E),
                    ],
                    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
                  ),
                  border: Border.all(color: const Color(0xFF261906), width: 1.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x88000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '◄ TUNE ►',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: const Color(0xFF2E1A04),
                      shadows: SkeuoShadows.engravedText(
                        darkShadow: const Color(0x66000000),
                        highlight: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadioDialTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const int count = 35;
    final tickPaint = Paint()
      ..color = const Color(0x88E8C88B)
      ..strokeWidth = 1.0;
    final centerLinePaint = Paint()
      ..color = const Color(0x44E8C88B)
      ..strokeWidth = 0.8;

    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), centerLinePaint);

    for (int i = 0; i < count; i++) {
      final x = (size.width / (count - 1)) * i;
      final isMajor = i % 5 == 0;
      final h = isMajor ? 16.0 : 8.0;
      canvas.drawLine(
        Offset(x, (size.height - h) / 2),
        Offset(x, (size.height + h) / 2),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
