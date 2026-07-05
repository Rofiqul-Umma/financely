import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int kPinLength = 6;

/// A 6-digit PIN entry surface: title, dot indicator, numeric keypad and an
/// optional biometric shortcut. Owns the digit buffer; the parent decides what
/// happens when six digits are entered via [onCompleted].
class PinEntryView extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showBiometric;
  final VoidCallback? onBiometric;

  /// When false the digit keypad is disabled (e.g. during a lockout). The
  /// biometric shortcut stays active.
  final bool enabled;

  /// Optional widget rendered below the keypad (e.g. a "forgot passcode" link).
  final Widget? footer;

  /// Called once six digits are entered. Return `true` to accept (the parent
  /// takes over), or `false` to reject — the view shakes and clears.
  final Future<bool> Function(String pin) onCompleted;

  const PinEntryView({
    super.key,
    required this.title,
    required this.onCompleted,
    this.subtitle,
    this.showBiometric = false,
    this.onBiometric,
    this.enabled = true,
    this.footer,
  });

  @override
  State<PinEntryView> createState() => _PinEntryViewState();
}

class _PinEntryViewState extends State<PinEntryView>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _busy = false;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  Future<void> _onDigit(String d) async {
    if (!widget.enabled || _busy || _pin.length >= kPinLength) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += d);
    if (_pin.length == kPinLength) {
      setState(() => _busy = true);
      final accepted = await widget.onCompleted(_pin);
      if (!mounted) return;
      if (accepted) {
        setState(() => _busy = false);
      } else {
        await _shake.forward(from: 0);
        if (!mounted) return;
        setState(() {
          _pin = '';
          _busy = false;
        });
      }
    }
  }

  void _onBackspace() {
    if (!widget.enabled || _busy || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, size: 40, color: scheme.primary),
          const SizedBox(height: 16),
          Text(widget.title, style: text.titleLarge, textAlign: TextAlign.center),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),
          AnimatedBuilder(
            animation: _shake,
            builder: (context, child) {
              final dx = _shake.isAnimating
                  ? 8 * (1 - _shake.value) * _sineWave(_shake.value)
                  : 0.0;
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: _PinDots(filled: _pin.length),
          ),
          const SizedBox(height: 40),
          Opacity(
            opacity: widget.enabled ? 1 : 0.4,
            child: _Keypad(
              onDigit: _onDigit,
              onBackspace: _onBackspace,
              showBiometric: widget.showBiometric,
              onBiometric: widget.onBiometric,
            ),
          ),
          if (widget.footer != null) ...[
            const SizedBox(height: 8),
            widget.footer!,
          ],
        ],
      ),
    );
  }

  double _sineWave(double t) {
    // Two full oscillations across the animation for a shake feel.
    const twoPi = 6.28318530718;
    return (t * twoPi * 2).remainder(twoPi) > 3.14159 ? -1 : 1;
  }
}

class _PinDots extends StatelessWidget {
  final int filled;
  const _PinDots({required this.filled});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < kPinLength; i++)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? scheme.primary : Colors.transparent,
              border: Border.all(
                color: i < filled ? scheme.primary : scheme.outline,
                width: 2,
              ),
            ),
          ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool showBiometric;
  final VoidCallback? onBiometric;

  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.showBiometric,
    this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [for (final d in row) _DigitKey(d, () => onDigit(d))],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              showBiometric && onBiometric != null
                  ? _IconKey(Icons.fingerprint_rounded, onBiometric!)
                  : const SizedBox(width: 88, height: 88),
              _DigitKey('0', () => onDigit('0')),
              _IconKey(Icons.backspace_outlined, onBackspace),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitKey extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;
  const _DigitKey(this.digit, this.onTap);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return _KeyBase(
      onTap: onTap,
      child: Text(
        digit,
        style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IconKey extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconKey(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return _KeyBase(onTap: onTap, child: Icon(icon, size: 26));
  }
}

class _KeyBase extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _KeyBase({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
