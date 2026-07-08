import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/bubble_background.dart';
import '../widgets/azhly_logo.dart';
import '../widgets/theme_toggle.dart';
import 'role_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool showPass = false;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController(text: 'user@azhly.edu');
  final passCtrl = TextEditingController(text: 'password');

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final state = context.read<AppState>();
    state.login(nameCtrl.text.trim(), emailCtrl.text.trim(), AppRole.student);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    InputDecoration inputDeco(String label) => InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12, color: colors.textMuted),
          filled: true,
          fillColor: colors.inputBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.inputBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.inputBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppPalette.purple, width: 1.5)),
        );

    return Scaffold(
      body: BubbleBackground(
        isDark: state.isDarkMode,
        child: SafeArea(
          child: Column(
            children: [
              const Align(alignment: Alignment.topRight, child: Padding(padding: EdgeInsets.all(16), child: ThemeToggleButton())),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        children: [
                          AzhlyLogo(size: 76, isDark: state.isDarkMode),
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (b) => const LinearGradient(colors: [AppPalette.purple, AppPalette.pink]).createShader(b),
                            child: const Text('AZHly', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                          Text('SMART ROOM BOOKING', style: TextStyle(fontSize: 10, letterSpacing: 2.5, color: colors.textMuted)),
                          const SizedBox(height: 28),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colors.cardBg,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: colors.cardBorder),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: AppPalette.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                                  child: Row(
                                    children: ['Login', 'Sign Up'].map((label) {
                                      final active = (label == 'Login') == isLogin;
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () => setState(() => isLogin = label == 'Login'),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                              gradient: active ? AppPalette.purpleGradient2 : null,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(label,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: active ? Colors.white : colors.accent.withValues(alpha: 0.7),
                                                )),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (!isLogin) ...[
                                  TextField(controller: nameCtrl, style: TextStyle(color: colors.textPrimary, fontSize: 14), decoration: inputDeco('Full Name')),
                                  const SizedBox(height: 14),
                                ],
                                TextField(controller: emailCtrl, style: TextStyle(color: colors.textPrimary, fontSize: 14), decoration: inputDeco('Email')),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: passCtrl,
                                  obscureText: !showPass,
                                  style: TextStyle(color: colors.textPrimary, fontSize: 14),
                                  decoration: inputDeco('Password').copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(showPass ? Icons.visibility_off : Icons.visibility, size: 18, color: colors.textMuted),
                                      onPressed: () => setState(() => showPass = !showPass),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(gradient: AppPalette.purpleGradient, borderRadius: BorderRadius.circular(14)),
                                    child: ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      child: Text(isLogin ? 'Sign In' : 'Create Account',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
