import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_database.dart';
import 'auth_page.dart';

const Color _blue = Color(0xFF2563EB);
const Color _ink = Color(0xFF15233B);
const Color _muted = Color(0xFF8192AE);
const Color _pageBackground = Color(0xFFF5F8FC);

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase _db = AppDatabase();
  final TextEditingController _itemController = TextEditingController();
  String _selectedPeriod = '30d';

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    final item = _itemController.text.trim();
    if (item.isEmpty) return;

    _db.addItem(widget.userEmail, item);
    _itemController.clear();
    Navigator.pop(context);
    setState(() {});
  }

  void _showAddItemModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cadastrar item perdido/achado',
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _itemController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Descreva o item e o local...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _addNewItem,
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Publicar item'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DashboardHeader(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (period) {
                setState(() => _selectedPeriod = period);
              },
              onLogout: _logout,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 18),
                child: Column(
                  children: [
                    const _StatisticsCards(),
                    const SizedBox(height: 14),
                    const _DistributionCard(),
                    const SizedBox(height: 14),
                    const _LocationsCard(),
                    if (_db.getItems(widget.userEmail).isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _RecentItemsCard(items: _db.getItems(widget.userEmail)),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _DashboardNavigation(onPublish: _showAddItemModal),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final VoidCallback onLogout;

  const _DashboardHeader({
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 17, 18, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estatísticas do\ncampus',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _PeriodSelector(
                selectedPeriod: selectedPeriod,
                onChanged: onPeriodChanged,
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'UnDF · Setembro 2026',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ),
              SizedBox(
                height: 28,
                width: 28,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  tooltip: 'Opções da conta',
                  icon: const Icon(Icons.more_horiz, color: _muted, size: 20),
                  onSelected: (value) {
                    if (value == 'logout') onLogout();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'logout',
                      child: Text('Sair da conta'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['7d', '30d', '90d'].map((period) {
          final selected = selectedPeriod == period;
          return GestureDetector(
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? _blue : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: selected ? Colors.white : _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatisticsCards extends StatelessWidget {
  const _StatisticsCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatisticCard(
            title: 'Itens perdidos',
            value: '74',
            note: '+12% no\nperíodo',
            noteColor: Color(0xFFDC2626),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatisticCard(
            title: 'Itens\n encontrados',
            value: '52',
            note: '+8% no\nperíodo',
            noteColor: Color(0xFF059669),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatisticCard(
            title: 'Taxa de\nrecuperação',
            value: '70%',
            note: 'de itens\nencerrados',
            highlighted: true,
          ),
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String note;
  final Color noteColor;
  final bool highlighted;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.note,
    this.noteColor = const Color(0xFFFFFFFF),
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted ? Colors.white : _ink;
    return Container(
      height: 121,
      padding: const EdgeInsets.fromLTRB(12, 12, 9, 10),
      decoration: BoxDecoration(
        color: highlighted ? _blue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: highlighted ? null : Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: highlighted
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF172B4D).withValues(alpha: 0.06),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: highlighted ? const Color(0xFFDCE8FF) : _muted,
              fontSize: 9.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: foreground,
              fontSize: 21,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: TextStyle(
              color: highlighted ? Colors.white : noteColor,
              fontSize: 9.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard();

  static const List<_CategoryData> _categories = [
    _CategoryData('Eletrônicos', '25', Color(0xFF2563EB)),
    _CategoryData('Documentos', '16', Color(0xFF5C9BFF)),
    _CategoryData('Vestuário', '13', Color(0xFF8FBCFF)),
    _CategoryData('Outros', '20', Color(0xFFBED9FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeading(
            title: 'Distribuição dos itens perdidos',
            trailing: '74 itens',
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 125,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomPaint(
                    painter: _DonutChartPainter(
                      values: const [25, 16, 13, 20],
                      colors: _categories
                          .map((category) => category.color)
                          .toList(),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '25',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Eletrônicos',
                            style: TextStyle(color: _muted, fontSize: 7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _categories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: category.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(
                                      color: Color(0xFF52627D),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  category.count,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
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

class _CategoryData {
  final String name;
  final String count;
  final Color color;

  const _CategoryData(this.name, this.count, this.color);
}

class _LocationsCard extends StatelessWidget {
  const _LocationsCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Locais do Campus',
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              _LegendDot(color: _blue, label: 'Perdidos'),
              SizedBox(width: 14),
              _LegendDot(color: Color(0xFFBED9FF), label: 'Encontrados'),
            ],
          ),
          const SizedBox(height: 8),
          const SizedBox(
            height: 175,
            width: double.infinity,
            child: CustomPaint(painter: _LocationsChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _RecentItemsCard extends StatelessWidget {
  final List<String> items;

  const _RecentItemsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Itens recentes',
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...items
              .take(3)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: _blue,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(color: _ink, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172B4D).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeading extends StatelessWidget {
  final String title;
  final String trailing;

  const _CardHeading({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(trailing, style: const TextStyle(color: _muted, fontSize: 9)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF63738F), fontSize: 9),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height) * 0.82;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );
    final total = values.fold<double>(0, (sum, value) => sum + value);
    var startAngle = -math.pi / 2;
    for (var index = 0; index < values.length; index++) {
      final sweepAngle = values[index] / total * math.pi * 2;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = colors[index]
          ..style = PaintingStyle.stroke
          ..strokeWidth = side * 0.22
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweepAngle + 0.025;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.colors != colors;
}

class _LocationsChartPainter extends CustomPainter {
  const _LocationsChartPainter();

  static const List<int> _lost = [18, 14, 22, 9, 11];
  static const List<int> _found = [12, 10, 15, 7, 8];
  static const List<String> _labels = [
    'Bloco A',
    'Bloco B',
    'Biblioteca',
    'RU',
    'Lab',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const left = 25.0;
    const right = 3.0;
    const top = 9.0;
    const bottom = 25.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;
    final gridPaint = Paint()
      ..color = const Color(0xFFEDF2F8)
      ..strokeWidth = 1;
    final labelStyle = TextStyle(
      color: _muted,
      fontSize: 7,
      fontFamily: 'Roboto',
    );

    for (var value = 0; value <= 25; value += 5) {
      final y = top + chartHeight - (value / 25) * chartHeight;
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
      final text = TextPainter(
        text: TextSpan(text: '$value', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(0, y - text.height / 2));
    }

    final groupWidth = chartWidth / _labels.length;
    final barWidth = math.min(13.0, groupWidth * 0.29);
    for (var index = 0; index < _labels.length; index++) {
      final center = left + groupWidth * (index + 0.5);
      final lostHeight = _lost[index] / 25 * chartHeight;
      final foundHeight = _found[index] / 25 * chartHeight;
      final lostRect = Rect.fromLTWH(
        center - barWidth - 1,
        top + chartHeight - lostHeight,
        barWidth,
        lostHeight,
      );
      final foundRect = Rect.fromLTWH(
        center + 1,
        top + chartHeight - foundHeight,
        barWidth,
        foundHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          lostRect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        Paint()..color = _blue,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          foundRect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFFBED9FF),
      );
      final label = TextPainter(
        text: TextSpan(text: _labels[index], style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: groupWidth);
      label.paint(
        canvas,
        Offset(center - label.width / 2, top + chartHeight + 7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LocationsChartPainter oldDelegate) => false;
}

class _DashboardNavigation extends StatelessWidget {
  final VoidCallback onPublish;

  const _DashboardNavigation({required this.onPublish});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE9EEF5))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _NavigationItem(icon: Icons.home_outlined, label: 'Início'),
          ),
          const Expanded(
            child: _NavigationItem(icon: Icons.search, label: 'Buscar'),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onPublish,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x332563EB),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
          const Expanded(
            child: _NavigationItem(
              icon: Icons.notifications_none_outlined,
              label: 'Notificações',
            ),
          ),
          const Expanded(
            child: _NavigationItem(
              icon: Icons.bar_chart_rounded,
              label: 'Dashboard',
              selected: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavigationItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _blue : _muted;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 21, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
