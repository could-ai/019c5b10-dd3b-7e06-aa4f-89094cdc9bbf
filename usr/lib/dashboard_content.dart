import 'dart:math';
import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return _buildDesktopLayout(context);
              } else {
                return _buildMobileLayout(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _ReadinessCard(),
              const SizedBox(height: 24),
              _ContinuePracticeCard(),
              const SizedBox(height: 24),
              _UpcomingAssessmentsCard(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _SkillRadarCard(),
              const SizedBox(height: 24),
              _WeeklyGoalsCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _ReadinessCard(),
        const SizedBox(height: 24),
        _SkillRadarCard(),
        const SizedBox(height: 24),
        _ContinuePracticeCard(),
        const SizedBox(height: 24),
        _WeeklyGoalsCard(),
        const SizedBox(height: 24),
        _UpcomingAssessmentsCard(),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final Widget content;
  final double? height;

  const _DashboardCard({
    required this.title,
    required this.content,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 24),
          Flexible(child: content),
        ],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Overall Readiness',
      content: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              percentage: 0.72,
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey.shade200,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '72',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  Text(
                    'Readiness Score',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 10;
    final strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SkillRadarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Skill Breakdown',
      height: 350,
      content: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: _RadarChartPainter(
              data: [75, 60, 80, 85, 70],
              labels: ['DSA', 'Sys Design', 'Comm', 'Resume', 'Aptitude'],
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;

  _RadarChartPainter({
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 30;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw webs
    for (int i = 1; i <= 5; i++) {
      final r = radius * (i / 5);
      final path = Path();
      for (int j = 0; j < 5; j++) {
        final angle = -pi / 2 + (2 * pi * j / 5);
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    // Draw axes and labels
    for (int j = 0; j < 5; j++) {
      final angle = -pi / 2 + (2 * pi * j / 5);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);

      // Draw labels
      final labelX = center.dx + (radius + 20) * cos(angle);
      final labelY = center.dy + (radius + 20) * sin(angle);
      
      textPainter.text = TextSpan(
        text: labels[j],
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );
    }

    // Draw data
    final dataPath = Path();
    final dataPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int j = 0; j < 5; j++) {
      final value = data[j] / 100;
      final angle = -pi / 2 + (2 * pi * j / 5);
      final x = center.dx + radius * value * cos(angle);
      final y = center.dy + radius * value * sin(angle);
      if (j == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ContinuePracticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Continue Practice',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last topic: Dynamic Programming',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.grey.shade200,
            color: Theme.of(context).primaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '3/10 completed',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGoalsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Weekly Goals',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Problems Solved',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '12/20',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 12 / 20,
            backgroundColor: Colors.grey.shade200,
            color: Theme.of(context).primaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayCircle(context, 'M', true),
              _buildDayCircle(context, 'T', true),
              _buildDayCircle(context, 'W', false),
              _buildDayCircle(context, 'T', true),
              _buildDayCircle(context, 'F', false),
              _buildDayCircle(context, 'S', true),
              _buildDayCircle(context, 'S', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCircle(BuildContext context, String day, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? Theme.of(context).primaryColor : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingAssessmentsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Upcoming Assessments',
      content: Column(
        children: [
          _buildAssessmentItem(
            context,
            'DSA Mock Test',
            'Tomorrow, 10:00 AM',
            Icons.code,
            Colors.blue,
          ),
          const Divider(height: 32),
          _buildAssessmentItem(
            context,
            'System Design Review',
            'Wed, 2:00 PM',
            Icons.architecture,
            Colors.orange,
          ),
          const Divider(height: 32),
          _buildAssessmentItem(
            context,
            'HR Interview Prep',
            'Friday, 11:00 AM',
            Icons.people,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400]),
      ],
    );
  }
}
