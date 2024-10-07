import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utilities/helper_functions.dart';

class ServiceCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String price;
  final String? salePrice;
  final int serviceId;
  final ValueChanged<bool> onSelectionChanged;
  final bool isSelected;
  final bool enableTap;
  final double? height;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.salePrice,
    required this.serviceId,
    required this.onSelectionChanged,
    this.isSelected = false,
    this.enableTap = true,
    this.height,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  void _toggleSelection() {
    if (!widget.enableTap) return;

    setState(() {
      isSelected = !isSelected;
      widget.onSelectionChanged(isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        // height: MediaQuery.of(context).size.width * 0.4,
        height: widget.height,
        width: MediaQuery.of(context).size.width * 0.24,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  _buildImage(widget.imagePath),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    widget.title,
                    minFontSize: 8,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: (widget.salePrice != null)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${formatPrice(widget.price)}',
                          style: TextStyle(
                            color: widget.salePrice != null
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (widget.salePrice != null)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: DiagonalLinePainter(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.salePrice != null) ...[
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${formatPrice(widget.salePrice!)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: MediaQuery.of(context).size.width * 0.17,
        width: MediaQuery.of(context).size.width * 0.24,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/square_logo.png',
            height: MediaQuery.of(context).size.width * 0.17,
            width: MediaQuery.of(context).size.width * 0.24,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        height: MediaQuery.of(context).size.width * 0.17,
        width: MediaQuery.of(context).size.width * 0.24,
        fit: BoxFit.cover,
      );
    }
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
