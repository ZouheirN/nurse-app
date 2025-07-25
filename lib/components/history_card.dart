import 'package:flutter/material.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';

import '../utilities/helper_functions.dart';

class HistoryCard extends StatefulWidget {
  final RequestsHistoryModel request;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.height / size.width;

    final isOngoing = widget.request.status == 'ongoing';
    final name = widget.request.name.toString();
    // final problemDescription = widget.request.problemDescription.toString();
    const problemDescription = 'Check out the details';
    final time = formatDateTimeForCard(widget.request.scheduledTime ?? widget.request.createdAt!);

    final sumOfPrices = widget.request.services
        .map((service) => num.parse(service.price.toString()))
        .reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: isOngoing
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        tileMode: TileMode.mirror,
                        colors: const [
                          Color.fromRGBO(19, 27, 10, 1),
                          Color.fromRGBO(101, 148, 54, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: SlideGradient(
                          controller.value,
                          size.height * aspectRatio,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //   color: Colors.grey,
                      //   width: 1,
                      // ),
                    ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/default.png',
                    // width: 80,
                    height: 73,
                    // fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isOngoing ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  problemDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(123, 180, 66, 1),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(-4, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '\$${formatPrice(sumOfPrices)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // if (service.discountPrice != null)
                                  //   Positioned.fill(
                                  //     child: CustomPaint(
                                  //       painter: DiagonalLinePainter(),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                time,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(142, 142, 142, 1),
                                ),
                              ),
                              // if (service.discountPrice != null) ...[
                              //   const SizedBox(width: 5),
                              //   FittedBox(
                              //     fit: BoxFit.scaleDown,
                              //     child: Text(
                              //       '\$${formatPrice(service.discountPrice!)}',
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w700,
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
                  // Expanded(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       for (final service in widget.services)
                  //         Padding(
                  //           padding: const EdgeInsets.only(bottom: 5),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Flexible(
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       service.name.toString(),
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: widget.isOngoing
                  //                             ? Colors.white
                  //                             : Colors.black,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       widget.description,
                  //                       style: const TextStyle(
                  //                         fontSize: 14,
                  //                         color: Colors.grey,
                  //                       ),
                  //                       maxLines: 2,
                  //                       overflow: TextOverflow.ellipsis,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               // const SizedBox(width: 5),
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 children: [
                  //                   Stack(
                  //                     alignment: Alignment.center,
                  //                     children: [
                  //                       FittedBox(
                  //                         fit: BoxFit.scaleDown,
                  //                         child: Container(
                  //                           height: 28,
                  //                           width: 28,
                  //                           decoration: const BoxDecoration(
                  //                             color: Color.fromRGBO(
                  //                                 123, 180, 66, 1),
                  //                             shape: BoxShape.circle,
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                 color: Colors.grey,
                  //                                 blurRadius: 4,
                  //                                 spreadRadius: 0,
                  //                                 offset: Offset(-4, 4),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           child: Center(
                  //                             child: Text(
                  //                               '\$${formatPrice(
                  //                                 num.parse(
                  //                                   service.price.toString(),
                  //                                 ),
                  //                               )}',
                  //                               style: const TextStyle(
                  //                                 color: Colors.white,
                  //                                 fontSize: 8,
                  //                                 fontWeight: FontWeight.w700,
                  //                               ),
                  //                               textAlign: TextAlign.center,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       // if (service.discountPrice != null)
                  //                       //   Positioned.fill(
                  //                       //     child: CustomPaint(
                  //                       //       painter: DiagonalLinePainter(),
                  //                       //     ),
                  //                       //   ),
                  //                     ],
                  //                   ),
                  //                   const SizedBox(height: 10),
                  //                   Text(
                  //                     widget.time,
                  //                     textAlign: TextAlign.right,
                  //                     style: const TextStyle(
                  //                       fontSize: 12,
                  //                       fontWeight: FontWeight.w400,
                  //                       color: Color.fromRGBO(142, 142, 142, 1),
                  //                     ),
                  //                   ),
                  //                   // if (service.discountPrice != null) ...[
                  //                   //   const SizedBox(width: 5),
                  //                   //   FittedBox(
                  //                   //     fit: BoxFit.scaleDown,
                  //                   //     child: Text(
                  //                   //       '\$${formatPrice(service.discountPrice!)}',
                  //                   //       style: const TextStyle(
                  //                   //         fontSize: 14,
                  //                   //         fontWeight: FontWeight.w700,
                  //                   //       ),
                  //                   //     ),
                  //                   //   ),
                  //                   // ],
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       // const SizedBox(height: 5),
                  //       // Row(
                  //       //   crossAxisAlignment: CrossAxisAlignment.end,
                  //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       //   children: [
                  //       //     // Flexible(
                  //       //     //   child: Text(
                  //       //     //     description,
                  //       //     //     style: const TextStyle(
                  //       //     //       fontSize: 14,
                  //       //     //       color: Colors.grey,
                  //       //     //     ),
                  //       //     //     maxLines: 2,
                  //       //     //     overflow: TextOverflow.ellipsis,
                  //       //     //   ),
                  //       //     // ),
                  //       //     Text(
                  //       //       time,
                  //       //       textAlign: TextAlign.right,
                  //       //       style: const TextStyle(
                  //       //         fontSize: 12,
                  //       //         fontWeight: FontWeight.w300,
                  //       //         color: Colors.black,
                  //       //       ),
                  //       //     ),
                  //       //   ],
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SlideGradient implements GradientTransform {
  final double value;
  final double offset;

  const SlideGradient(this.value, this.offset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final dist = value * (bounds.width + offset);
    return Matrix4.identity()..translate(-dist);
  }
}
