import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';

class DevelopmentCanvas extends StatefulWidget {
  final String imageUrl;
  final String? beforeImageUrl;
  final bool isInitial;

  const DevelopmentCanvas({
    super.key,
    required this.imageUrl,
    this.beforeImageUrl,
    this.isInitial = false,
  });

  @override
  State<DevelopmentCanvas> createState() => _DevelopmentCanvasState();
}

class _DevelopmentCanvasState extends State<DevelopmentCanvas> {
  late bool _showAfter;

  @override
  void initState() {
    super.initState();
    _showAfter = widget.isInitial || widget.beforeImageUrl == null;
    if (!_showAfter) {
      _startTransition();
    }
  }

  void _startTransition() async {
    // Before 1.4s
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() {
        _showAfter = true;
      });
    }
  }

  @override
  void didUpdateWidget(DevelopmentCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl && widget.beforeImageUrl != null) {
      setState(() {
        _showAfter = false;
      });
      _startTransition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: _buildImage(widget.beforeImageUrl ?? widget.imageUrl),
      secondChild: _buildImage(widget.imageUrl),
      crossFadeState: _showAfter ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 1100),
      firstCurve: Curves.easeInOutSine,
      secondCurve: Curves.easeInOutSine,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          children: [
            Positioned.fill(key: bottomChildKey, child: bottomChild),
            Positioned.fill(key: topChildKey, child: topChild),
          ],
        );
      },
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return const Center(child: Text('Empty', style: TextStyle(color: EmeraldWashTheme.secondaryText)));
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(strokeWidth: 1, color: EmeraldWashTheme.surface),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error_outline),
    );
  }
}
