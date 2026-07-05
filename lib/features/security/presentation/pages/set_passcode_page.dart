import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_lock_cubit.dart';
import '../widgets/pin_entry_view.dart';

/// Two-step PIN capture used to set or change the passcode. Pops `true` on
/// success.
class SetPasscodePage extends StatefulWidget {
  /// When true, keeps the passcode enabled (change flow) instead of enabling it.
  final bool isChange;

  const SetPasscodePage({super.key, this.isChange = false});

  static Future<bool?> show(BuildContext context, {bool isChange = false}) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SetPasscodePage(isChange: isChange),
      ),
    );
  }

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

enum _Step { create, confirm }

class _SetPasscodePageState extends State<SetPasscodePage> {
  _Step _step = _Step.create;
  String? _first;

  Future<bool> _onCreate(String pin) async {
    setState(() {
      _first = pin;
      _step = _Step.confirm;
    });
    return true;
  }

  Future<bool> _onConfirm(String pin) async {
    if (pin != _first) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs did not match. Try again.')),
      );
      setState(() {
        _first = null;
        _step = _Step.create;
      });
      return false;
    }
    final cubit = context.read<AppLockCubit>();
    if (widget.isChange) {
      await cubit.changePasscode(pin);
    } else {
      await cubit.enablePasscode(pin);
    }
    if (mounted) Navigator.of(context).pop(true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isConfirm = _step == _Step.confirm;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isChange ? 'Change passcode' : 'Set passcode'),
      ),
      body: SafeArea(
        child: PinEntryView(
          key: ValueKey(_step),
          title: isConfirm ? 'Confirm passcode' : 'Create a passcode',
          subtitle: isConfirm
              ? 'Re-enter your 6-digit passcode'
              : 'Choose a 6-digit passcode',
          onCompleted: isConfirm ? _onConfirm : _onCreate,
        ),
      ),
    );
  }
}
