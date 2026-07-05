import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_lock_cubit.dart';
import '../widgets/pin_entry_view.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Drives the lockout countdown and clears it once it expires.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      context.read<AppLockCubit>().refreshLockout();
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _tryBiometric() {
    final cubit = context.read<AppLockCubit>();
    if (cubit.state.canUseBiometric) cubit.unlockWithBiometric();
  }

  Future<void> _forgot() async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<AppLockCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forgot passcode?'),
        content: const Text(
          'A local passcode cannot be recovered. To regain access, Financely '
          'will remove the passcode and erase all transactions and accounts on '
          'this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Erase & reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.forgotPasscode();
      messenger.showSnackBar(
        const SnackBar(content: Text('Passcode removed and data erased.')),
      );
    }
  }

  String _formatCooldown(Duration remaining) {
    // Round up so the countdown never displays 0 while still locked.
    final total = remaining.inSeconds + 1;
    if (total < 60) return '${total}s';
    final m = total ~/ 60;
    final s = total % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, state) {
        final remaining = state.lockoutRemaining;
        final lockedOut = remaining != null;
        return Scaffold(
          body: SafeArea(
            child: PinEntryView(
              title: 'Enter passcode',
              subtitle: lockedOut
                  ? 'Too many attempts. Try again in ${_formatCooldown(remaining)}'
                  : 'Unlock Financely to continue',
              enabled: !lockedOut,
              showBiometric: state.canUseBiometric,
              onBiometric: _tryBiometric,
              onCompleted: (pin) =>
                  context.read<AppLockCubit>().unlockWithPin(pin),
              footer: TextButton(
                onPressed: _forgot,
                child: const Text('Forgot passcode?'),
              ),
            ),
          ),
        );
      },
    );
  }
}
