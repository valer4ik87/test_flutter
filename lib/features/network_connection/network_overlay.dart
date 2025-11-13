import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/network_bloc.dart';
import 'bloc/network_state.dart';

class NetworkOverlay extends StatefulWidget {
  final Widget child;

  const NetworkOverlay({required this.child, Key? key}) : super(key: key);

  @override
  _NetworkOverlayState createState() => _NetworkOverlayState();
}

class _NetworkOverlayState extends State<NetworkOverlay> {
  late Widget child;
  OverlayEntry? _overlayEntry;
  bool _isShown = false;

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: ColoredBox(
              color: Color.fromARGB(255, 255, 0, 0),
              child: Text(
                'Network unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Показ баннера
  void _showOverlay(BuildContext context) {
    if (_isShown) return;
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    _isShown = true;
  }

  // Скрытие баннера
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShown = false;
  }

  @override
  Widget build(BuildContext contextGlobal) {
    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state is NetworkOffline) {
          _showOverlay(contextGlobal);
        } else if (state is NetworkOnline) {
          _hideOverlay();
        }
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}
