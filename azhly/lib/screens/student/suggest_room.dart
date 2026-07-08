import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/room_card.dart';

class SuggestRoomPage extends StatefulWidget {
  const SuggestRoomPage({super.key});

  @override
  State<SuggestRoomPage> createState() => _SuggestRoomPageState();
}

class _SuggestRoomPageState extends State<SuggestRoomPage> {
  final queryCtrl = TextEditingController();
  Room? selected;
  final dateCtrl = TextEditingController(text: '2026-07-10');
  final startCtrl = TextEditingController(text: '14:00');
  final endCtrl = TextEditingController(text: '15:30');
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }
    state.submitRequest(
      roomId: selected!.id,
      roomName: selected!.name,
      requesterId: state.currentUser?.id ?? 's1',
      requesterName: '${state.currentUser?.name} (Student)',
      requesterRole: AppRole.student,
      date: dateCtrl.text,
      startTime: startCtrl.text,
      endTime: endCtrl.text,
      purpose: purposeCtrl.text.trim(),
      forwardedFrom: 'Submitted via Student Portal',
    );
    setState(() {
      selected = null;
      purposeCtrl.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Suggestion submitted! Your CR will review it.')));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final filtered = state.rooms.where((r) {
      final q = queryCtrl.text.toLowerCase();
      return r.name.toLowerCase().contains(q) || r.building.toLowerCase().contains(q);
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
        Text('Suggest a Room 💡', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text('Your suggestion goes to CR → Teacher for approval', style: TextStyle(fontSize: 11, color: colors.textMuted)),
        const SizedBox(height: 14),
        TextField(
          controller: queryCtrl,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 13, color: colors.textPrimary),
          decoration: deco('Search rooms...').copyWith(prefixIcon: Icon(Icons.search, size: 18, color: colors.textMuted)),
        ),
        const SizedBox(height: 14),
        if (selected != null)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppPalette.purple.withValues(alpha: 0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text('Selected: ${selected!.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.accent))),
                  GestureDetector(onTap: () => setState(() => selected = null), child: Icon(Icons.close, size: 16, color: colors.textMuted)),
                ]),
                Text('${selected!.building} · ${selected!.capacity} seats', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextField(controller: dateCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('Date'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: startCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('Start'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: endCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('End'))),
                ]),
                const SizedBox(height: 8),
                TextField(controller: purposeCtrl, style: TextStyle(fontSize: 12, color: colors.textPrimary), decoration: deco('e.g. Group study session')),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: AppPalette.purpleGradient, borderRadius: BorderRadius.circular(14)),
                    child: ElevatedButton(
                      onPressed: () => _submit(state),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Submit Suggestion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ...filtered.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RoomCard(
            room: r, isDark: state.isDarkMode,
            showRequest: selected == null,
            onRequest: (room) => setState(() => selected = room),
          ),
        )),
      ],
    );
  }
}
