import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const _bookingData = [
    {'day': 'Mon', 'bookings': 12.0, 'conflicts': 2.0},
    {'day': 'Tue', 'bookings': 8.0, 'conflicts': 1.0},
    {'day': 'Wed', 'bookings': 15.0, 'conflicts': 3.0},
    {'day': 'Thu', 'bookings': 6.0, 'conflicts': 0.0},
    {'day': 'Fri', 'bookings': 10.0, 'conflicts': 1.0},
  ];

  Widget _statCard(AppColors colors, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
          Text(label, style: TextStyle(fontSize: 10, color: colors.textMuted)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    final totalBookings = state.requests.length;
    final conflicts = state.requests.where((r) => r.status == RequestStatus.rejected).length;
    final approvedCount = state.requests.where((r) => r.status == RequestStatus.approved).length;
    final freeRooms = state.rooms.where((r) => r.status == RoomStatus.free).length;
    final occupiedRooms = state.rooms.where((r) => r.status == RoomStatus.occupied).length;
    final regularRooms = state.rooms.where((r) => r.status == RoomStatus.regular).length;
    final rejectedWithReason = state.requests.where((r) => r.status == RequestStatus.rejected && r.rejectionReason != null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Admin Analytics 📊', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text('System is self-governing. Reports only.', style: TextStyle(fontSize: 11, color: colors.textMuted)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10, crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _statCard(colors, 'Total Requests', '$totalBookings', Icons.menu_book_rounded, AppPalette.purple),
            _statCard(colors, 'Conflicts (FCFS)', '$conflicts', Icons.warning_amber_rounded, AppPalette.pink),
            _statCard(colors, 'Approved', '$approvedCount', Icons.trending_up_rounded, AppPalette.green),
            _statCard(colors, 'Free Rooms', '$freeRooms', Icons.people_outline, AppPalette.amber),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weekly Booking Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= _bookingData.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(_bookingData[idx]['day'] as String, style: TextStyle(fontSize: 10, color: colors.textMuted)),
                        );
                      })),
                    ),
                    barGroups: List.generate(_bookingData.length, (i) {
                      final d = _bookingData[i];
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: d['bookings'] as double, color: AppPalette.purple, width: 8, borderRadius: BorderRadius.circular(4)),
                        BarChartRodData(toY: d['conflicts'] as double, color: AppPalette.pink, width: 8, borderRadius: BorderRadius.circular(4)),
                      ]);
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                _legendDot(AppPalette.purple, 'Bookings', colors),
                const SizedBox(width: 16),
                _legendDot(AppPalette.pink, 'Conflicts', colors),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Status Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
              const SizedBox(height: 14),
              Row(children: [
                SizedBox(
                  width: 110, height: 110,
                  child: PieChart(PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(value: freeRooms.toDouble(), color: AppPalette.green, showTitle: false, radius: 24),
                      PieChartSectionData(value: occupiedRooms.toDouble(), color: AppPalette.pink, showTitle: false, radius: 24),
                      PieChartSectionData(value: regularRooms.toDouble(), color: AppPalette.amber, showTitle: false, radius: 24),
                    ],
                  )),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pieLegendRow('Free', freeRooms, AppPalette.green, colors),
                    _pieLegendRow('Occupied', occupiedRooms, AppPalette.pink, colors),
                    _pieLegendRow('Regular', regularRooms, AppPalette.amber, colors),
                  ],
                ),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FCFS Resolution Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
              const SizedBox(height: 10),
              if (rejectedWithReason.isEmpty)
                Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('No conflicts recorded', style: TextStyle(fontSize: 12, color: colors.textMuted))))
              else
                ...rejectedWithReason.map((r) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppPalette.pink.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppPalette.pink.withValues(alpha: 0.2))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⚡ Conflict – ${r.roomName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppPalette.pink)),
                          const SizedBox(height: 3),
                          Text(r.rejectionReason ?? '', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label, AppColors colors) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: colors.textMuted)),
      ]);

  Widget _pieLegendRow(String label, int value, Color color, AppColors colors) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, color: colors.textPrimary)),
          const SizedBox(width: 8),
          Text('$value', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ]),
      );
}
