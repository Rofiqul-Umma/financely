import 'package:flutter/widgets.dart';

/// Material 3 window size classes used to drive adaptive layouts.
enum WindowSize { compact, medium, expanded, large }

/// Breakpoints (logical pixels) following Material 3 window size class guidance.
const double kMediumBreakpoint = 600;
const double kExpandedBreakpoint = 840;
const double kLargeBreakpoint = 1240;

WindowSize windowSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < kMediumBreakpoint) return WindowSize.compact;
  if (width < kExpandedBreakpoint) return WindowSize.medium;
  if (width < kLargeBreakpoint) return WindowSize.expanded;
  return WindowSize.large;
}

extension ResponsiveContext on BuildContext {
  WindowSize get windowSize => windowSizeOf(this);

  /// Phone portrait — bottom navigation.
  bool get isCompact => windowSize == WindowSize.compact;

  /// Tablet and larger — side navigation and multi-pane layouts.
  bool get isTabletOrLarger => windowSize != WindowSize.compact;

  /// Wide layouts that can host a two-pane dashboard.
  bool get isExpandedOrLarger =>
      windowSize == WindowSize.expanded || windowSize == WindowSize.large;
}
