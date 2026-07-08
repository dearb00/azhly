import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'azhly_logo.dart';

const _steps = ['Fetching Timetable...', 'Checking Conflicts...', 'Allocating Room...', 'Completed!'];

/// The automated "Smart Engine" mini card — pops up mid-screen whenever a
/// room request is submitted, simulating the backend automatically checking
/// the timetable, allocating a room, and detecting conflicts (FCFS).
class SmartEngineModal extends StatelessWidget {
  const SmartEngineModal({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.smartEngineActive) return const SizedBox.shrink();

    final colors = AppColors(state.isDarkMode);
    final currentIdx = _steps.indexOf(state.smartEngineStep);

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.55),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.modalBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppPalette.purple.withOpacity(0.4)),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 30)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AzhlyLogo(size: 64, isDark: state.isDarkMode),
                  const SizedBox(height: 12),
                  Text('Smart Engine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.accent)),
                  const SizedBox(height: 3),
                  Text('Processing your room request...', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                  const SizedBox(height: 18),

                  if (state.smartEngineResult == SmartEngineResult.none) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.smartEngineStep, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                        Text('${state.smartEngineProgress}%', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: state.smartEngineProgress / 100,
                        minHeight: 8,
                        backgroundColor: AppPalette.purple.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation(AppPalette.pink),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._steps.asMap().entries.map((e) {
                      final i = e.key;
                      final label = e.value;
                      final done = i < currentIdx;
                      final active = i == currentIdx;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: done ? AppPalette.green : active ? AppPalette.purple : colors.textMuted.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                                color: done ? AppPalette.green : active ? colors.accent : colors.textMuted.withOpacity(0.5),
                                decoration: done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  if (state.smartEngineResult == SmartEngineResult.approved)
                    Column(children: [
                      const Icon(Icons.check_circle, size: 48, color: AppPalette.green),
                      const SizedBox(height: 8),
                      const Text('Room Allocated!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppPalette.green)),
                      const SizedBox(height: 4),
                      Text('Your booking has been confirmed successfully.',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                    ]),

                  if (state.smartEngineResult == SmartEngineResult.conflict)
                    Column(children: [
                      const Icon(Icons.warning_rounded, size: 48, color: AppPalette.pink),
                      const SizedBox(height: 8),
                      const Text('Conflict Detected', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppPalette.pink)),
                      const SizedBox(height: 4),
                      Text('Request rejected via FCFS policy. Check notifications for details.',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                    ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
