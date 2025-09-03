import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utilities/helper_functions.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:badges/badges.dart' as badges;

class ServiceCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final num price;
  final num? salePrice;
  final int serviceId;
  final ValueChanged<bool> onSelectionChanged;
  final bool isSelected;
  final bool enableTap;
  final double? height;
  final String? description;

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
    required this.description,
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

  void _showDescription() {
    final description = widget.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Service Description'),
          content: SingleChildScrollView(
            child: Text(description ?? 'No description available.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: badges.Badge(
        showBadge: widget.salePrice != null,
        stackFit: StackFit.passthrough,
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Color.fromRGBO(123, 180, 66, 1),
        ),
        badgeContent: Container(
          height: 25,
          width: 25,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(123, 180, 66, 1),
            shape: BoxShape.circle,
          ),
          child: const Text(
            'SALE',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 8,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        position: badges.BadgePosition.topEnd(
          top: 0,
          end: 0,
        ),
        child: Container(
          // height: MediaQuery.of(context).size.width * 0.4,
          height: widget.height,
          width: MediaQuery.of(context).size.width * 0.24,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withValues(alpha: 0.1),
            //     blurRadius: 4,
            //     spreadRadius: 2,
            //   ),
            // ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildImage(widget.imagePath),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      widget.title,
                      minFontSize: 10,
                      // maxLines: 4,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.salePrice != null
                            ? '\$${formatPrice(widget.salePrice!)}'
                            : '\$${formatPrice(widget.price)}',
                        style: TextStyle(
                          color: widget.salePrice != null
                              ? const Color.fromRGBO(52, 105, 0, 1)
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (widget.description != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: _showDescription,
                          child: const Icon(Icons.info_outline, size: 14),
                        ),
                      ),
                    ),
                  // if (widget.salePrice != null) ...[
                  //   const SizedBox(width: 5),
                  //   Flexible(
                  //     child: FittedBox(
                  //       fit: BoxFit.scaleDown,
                  //       child: Text(
                  //         '\$${formatPrice(widget.salePrice!)}',
                  //         style: const TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ],
          ),
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
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorWidget: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default.png',
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
