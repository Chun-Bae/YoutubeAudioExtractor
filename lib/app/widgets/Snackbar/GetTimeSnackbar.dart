import 'package:flutter/material.dart';

class GetTimeSnackbar {
  final BuildContext context;
  final String message;
  final Duration duration;
  static bool isShowing = false; // 현재 스낵바가 표시되고 있는지 확인하는 플래그
  static OverlayEntry? _currentOverlayEntry;

  GetTimeSnackbar({
    required this.context,
    required this.message,
    this.duration = const Duration(milliseconds: 2500),
  });

  void show() {
    // 현재 스낵바가 표시되고 있으면 기존 스낵바를 종료
    // if (isShowing) {
    //   _currentOverlayEntry?.remove();
    //   isShowing = false;
    // }

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _currentOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: _SnackbarContent(
            message: message,
            onDismissed: () {
              _currentOverlayEntry?.remove();
              isShowing = false;
              _currentOverlayEntry = null;
            },
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlayEntry!);
    isShowing = true;

    Future.delayed(duration).then((_) => hide());
  }

  void hide() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry?.remove();
      isShowing = false;
      _currentOverlayEntry = null;
    }
  }
}

class _SnackbarContent extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  _SnackbarContent({required this.message, required this.onDismissed});

  @override
  __SnackbarContentState createState() => __SnackbarContentState();
}

class __SnackbarContentState extends State<_SnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  void _dismiss() {
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.reverse().then((_) {
      widget.onDismissed();
    });
  }

  @override
  void didUpdateWidget(covariant _SnackbarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF0020715),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
