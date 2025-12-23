import 'package:flutter/material.dart';

/// Canadian theme colors
class CanadianColors {
  static const Color red = Color(0xFFC8102E);
  static const Color redLight = Color(0xFFE8394D);
  static const Color redDark = Color(0xFF9A0C24);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFAF8F5);
  static const Color gold = Color(0xFFD4AF37);
  static const Color warmGray = Color(0xFFF5F3F0);
  
  // Gradient colors
  static const List<Color> redGradient = [red, redLight];
  static const List<Color> softGradient = [Color(0xFFFFF5F5), Color(0xFFFAF8F5)];
  static const List<Color> darkGradient = [Color(0xFF1A1A2E), Color(0xFF16213E)];
}

/// Maple leaf painter for subtle background decorations
class MapleLeafPainter extends CustomPainter {
  final Color color;
  final double opacity;
  
  MapleLeafPainter({
    this.color = CanadianColors.red,
    this.opacity = 0.05,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..style = PaintingStyle.fill;

    // Draw subtle maple leaves in corners
    _drawMapleLeaf(canvas, paint, Offset(size.width * 0.1, size.height * 0.1), 80);
    _drawMapleLeaf(canvas, paint, Offset(size.width * 0.9, size.height * 0.3), 60);
    _drawMapleLeaf(canvas, paint, Offset(size.width * 0.15, size.height * 0.7), 50);
    _drawMapleLeaf(canvas, paint, Offset(size.width * 0.85, size.height * 0.85), 70);
  }

  void _drawMapleLeaf(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    // Simplified maple leaf shape
    path.moveTo(center.dx, center.dy - size * 0.5);
    path.lineTo(center.dx + size * 0.15, center.dy - size * 0.25);
    path.lineTo(center.dx + size * 0.4, center.dy - size * 0.3);
    path.lineTo(center.dx + size * 0.25, center.dy - size * 0.1);
    path.lineTo(center.dx + size * 0.5, center.dy + size * 0.1);
    path.lineTo(center.dx + size * 0.2, center.dy + size * 0.15);
    path.lineTo(center.dx + size * 0.25, center.dy + size * 0.4);
    path.lineTo(center.dx, center.dy + size * 0.25);
    path.lineTo(center.dx - size * 0.25, center.dy + size * 0.4);
    path.lineTo(center.dx - size * 0.2, center.dy + size * 0.15);
    path.lineTo(center.dx - size * 0.5, center.dy + size * 0.1);
    path.lineTo(center.dx - size * 0.25, center.dy - size * 0.1);
    path.lineTo(center.dx - size * 0.4, center.dy - size * 0.3);
    path.lineTo(center.dx - size * 0.15, center.dy - size * 0.25);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Canadian themed background with subtle maple leaves
class CanadianBackground extends StatelessWidget {
  final Widget child;
  final bool showMapleLeaves;
  final bool useDarkTheme;
  
  const CanadianBackground({
    super.key,
    required this.child,
    this.showMapleLeaves = true,
    this.useDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = useDarkTheme || Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark 
              ? CanadianColors.darkGradient
              : CanadianColors.softGradient,
        ),
      ),
      child: showMapleLeaves
          ? CustomPaint(
              painter: MapleLeafPainter(
                color: isDark ? Colors.white : CanadianColors.red,
                opacity: isDark ? 0.03 : 0.04,
              ),
              child: child,
            )
          : child,
    );
  }
}

/// Question card with Canadian styling
class CanadianQuestionCard extends StatelessWidget {
  final Widget child;
  final bool isHighlighted;
  
  const CanadianQuestionCard({
    super.key,
    required this.child,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted 
            ? Border.all(color: CanadianColors.red, width: 2)
            : Border.all(
                color: isDark 
                    ? Colors.white.withAlpha(25)
                    : CanadianColors.red.withAlpha(25),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withAlpha(50)
                : CanadianColors.red.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Canadian themed header card (like welcome banner)
class CanadianHeaderCard extends StatelessWidget {
  final Widget child;
  
  const CanadianHeaderCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CanadianColors.red, CanadianColors.redLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CanadianColors.red.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle maple leaf decoration
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.eco,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Maple leaf icon widget
class MapleLeafIcon extends StatelessWidget {
  final double size;
  final Color? color;
  
  const MapleLeafIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '🍁',
      style: TextStyle(fontSize: size),
    );
  }
}

/// Canadian styled button
class CanadianButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isPrimary;
  
  const CanadianButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: CanadianColors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: child,
      );
    }
    
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: CanadianColors.red,
        side: const BorderSide(color: CanadianColors.red),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: child,
    );
  }
}

/// Canadian achievement badge
class CanadianBadge extends StatelessWidget {
  final String emoji;
  final String title;
  final bool isUnlocked;
  
  const CanadianBadge({
    super.key,
    required this.emoji,
    required this.title,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? const LinearGradient(
                colors: [CanadianColors.red, CanadianColors.redLight],
              )
            : null,
        color: isUnlocked ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              color: isUnlocked ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
