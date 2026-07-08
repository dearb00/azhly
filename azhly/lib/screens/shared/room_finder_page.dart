import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/room_card.dart';

const _filters = ['All', 'Free', 'Occupied', 'Regular'];

class RoomFinderPage extends StatefulWidget {
  const RoomFinderPage({super.key});

  @override
  State<RoomFinderPage> createState() => _RoomFinderPageState();
}

class _RoomFinderPageState extends State<RoomFinderPage> {
  final queryCtrl = TextEditingController();
  String filter = 'All';
  Room? selected;
  final dateCtrl = TextEditingController(text: '2026-07-10');
  final startCtrl = TextEditingController(text: '10:00');
  final endCtrl = TextEditingController(text: '11:30');
  final purposeCtrl = TextEditingController();

  @override
  void dispose() {
    queryCtrl.dispose();
    dateCtrl.dispose();
    startCtrl.dispose();
    endCtrl.dispose();
    purposeCtrl.dispose();
    super.dispose();
  }

  void _submit(AppState state) {
    if (selected == null || purposeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields.')));
      return;
    }
    state.submitRequest(
      roomId: selected!.id,
      roomName: selected!.name,
      requesterId: state.currentUser?.id ?? 'u1',
      requesterName: state.currentUser?.name ?? '',
      requesterRole: state.currentUser?.role ?? AppRole.teacher,
      date: dateCtrl.text,
      startTime: startCtrl.text,
      endTime: endCtrl.text,
      purpose: purposeCtrl.text.trim(),
    );
    setState(() {
      selected = null;
      purposeCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final filtered = state.rooms.where((r) {
      final q = queryCtrl.text.toLowerCase();
      final matchQ = r.name.toLowerCase().contains(q) || r.building.toLowerCase().contains(q);
      final matchF = filter == 'All' || r.status.name == filter.toLowerCase();
      return matchQ && matchF;
    }).toList();

    InputDecoration deco(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12, color: colors.textMuted),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: colors.inputBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.inputBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.inputBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppPalette.purple)),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Room Finder 🔍', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        const SizedBox(height: 12),
        TextField(
          controller: queryCtrl,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 13, color: colors.textPrimary),
          decoration: deco('Search rooms or buildings...').copyWith(prefixIcon: Icon(Icons.search, size: 18, color: colors.textMuted)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _filters.map((f) {
              final active = filter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => filter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: active ? AppPalette.purpleGradient2 : null,
                      color: active ? null : colors.chipBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : colors.accent)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (selected != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppPalette.purple.withOpacity(0.5), width: 1.4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text('Booking: ${selected!.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.accent))),
                  GestureDetector(onTap: () => setState(() => selected = null), child: Icon(Icons.close, size: 16, color: colors.textMuted)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: TextField(controller: dateCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('Date'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: startCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('Start'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: endCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('End'))),
                ]),
                const SizedBox(height: 8),
                TextField(controller: purposeCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('Reason for booking')),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: AppPalette.purpleGradient, borderRadius: BorderRadius.circular(14)),
                    child: ElevatedButton(
                      onPressed: () => _submit(state),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Send to Smart Engine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Text('${filtered.length} room${filtered.length != 1 ? 's' : ''} found', style: TextStyle(fontSize: 11, color: colors.textMuted)),
        const SizedBox(height: 10),
        ...filtered.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoomCard(room: r, isDark: state.isDarkMode, showRequest: selected == null, onRequest: (room) => setState(() => selected = room)),
            )),
      ],
    );
  }
}
