import 'package:praxis/core/widgets/layout/platform_widget.dart';
import 'package:flutter/material.dart';

class PlatformGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final HitTestBehavior? behavior;

  const PlatformGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.onTapDown,
    this.onTapUp,
    this.behavior,
  });

  @override
  State<PlatformGestureDetector> createState() =>
      _PlatformGestureDetectorState();
}

class _PlatformGestureDetectorState extends State<PlatformGestureDetector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      onSecondaryTap: PlatformInfo.isDesktopPlatform
          ? widget.onSecondaryTap
          : null,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      behavior: widget.behavior,
      child: widget.child,
    );
  }
}

class HoverableWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, bool isHovered)? builder;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  final MouseCursor? cursor;

  const HoverableWidget({
    super.key,
    required this.child,
    this.builder,
    this.onHover,
    this.onExit,
    this.cursor,
  });

  @override
  State<HoverableWidget> createState() => _HoverableWidgetState();
}

class _HoverableWidgetState extends State<HoverableWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfo.isDesktopPlatform && !PlatformInfo.isWeb) {
      return widget.child;
    }

    return MouseRegion(
      cursor: widget.cursor ?? MouseCursor.defer,
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover?.call();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onExit?.call();
      },
      child: widget.builder?.call(context, _isHovered) ?? widget.child,
    );
  }
}

class ContextMenuRegion extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> menuItems;

  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfo.isDesktopPlatform && !PlatformInfo.isWeb) {
      return child;
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: child,
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height),
      ),
      items: menuItems.map((item) {
        return PopupMenuItem(
          enabled: item.enabled,
          onTap: item.onTap,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 20),
                const SizedBox(width: 12),
              ],
              Text(item.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;

  const ContextMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
  });
}

class TouchFeedbackButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const TouchFeedbackButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isMobilePlatform) {
      return Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      );
    }

    return HoverableWidget(
      cursor: onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      builder: (context, isHovered) {
        return Material(
          color: isHovered && onPressed != null
              ? (backgroundColor ?? Colors.transparent).withValues(alpha: 0.1)
              : (backgroundColor ?? Colors.transparent),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ),
        );
      },
      child: child,
    );
  }
}

class SwipeableWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double swipeThreshold;

  const SwipeableWidget({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.swipeThreshold = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfo.isMobilePlatform) {
      return child;
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > swipeThreshold) {
          onSwipeRight?.call();
        } else if (details.primaryVelocity! < -swipeThreshold) {
          onSwipeLeft?.call();
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > swipeThreshold) {
          onSwipeDown?.call();
        } else if (details.primaryVelocity! < -swipeThreshold) {
          onSwipeUp?.call();
        }
      },
      child: child,
    );
  }
}

class PlatformScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;
  final bool? thumbVisibility;
  final bool? trackVisibility;

  const PlatformScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isDesktopPlatform || PlatformInfo.isWeb) {
      return Scrollbar(
        controller: controller,
        thumbVisibility: thumbVisibility ?? true,
        trackVisibility: trackVisibility ?? false,
        child: child,
      );
    }

    return child;
  }
}
