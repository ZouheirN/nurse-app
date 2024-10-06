import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:nurse_app/components/service_card.dart';

class ServicesList extends StatefulWidget {
  final List<dynamic> services;
  final List<num> selectedServiceIds;

  const ServicesList({
    super.key,
    required this.services,
    required this.selectedServiceIds,
  });

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  int selectedPage = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: selectedPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandablePageView(
          controller: pageController,
          // physics: const NeverScrollableScrollPhysics(),
          // group each 9 services into a page, and create a new page if the services exceed 9, and handle index out of range
          children: List.generate(
            (widget.services.length / 9).ceil(),
            (index) {
              final startIndex = index * 9;
              final endIndex = startIndex + 9;

              return _buildServicesPage(
                widget.services.sublist(
                  startIndex,
                  endIndex > widget.services.length
                      ? widget.services.length
                      : endIndex,
                ),
              );
            },
          ),
          onPageChanged: (page) {
            setState(() {
              selectedPage = page;
            });
          },
        ),
        if (widget.services.length > 9)
          // add numbered buttons to navigate between pages
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 5,
            children: List.generate(
              (widget.services.length / 9).ceil(),
              (index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedPage == index
                            ? const Color(0xFF7BB442)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedPage == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildServicesPage(List<dynamic> services) {
    return IntrinsicSizeBuilder(
      subject: Row(
        children: services.map((service) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ServiceCard(
              serviceId: service['id'],
              imagePath:
                  service['service_pic'] ?? 'assets/images/square_logo.png',
              title: service['name'],
              price: service['price'],
              salePrice: service['discount_price'],
              onSelectionChanged: (isSelected) {},
            ),
          );
        }).toList(),
      ),
      builder: (context, subjectSize, subject) {
        return Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: services.map(
              (service) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ServiceCard(
                    height: subjectSize.height,
                    serviceId: service['id'],
                    imagePath: service['service_pic'] ??
                        'assets/images/square_logo.png',
                    title: service['name'],
                    price: service['price'],
                    isSelected:
                        widget.selectedServiceIds.contains(service['id']),
                    salePrice: service['discount_price'],
                    onSelectionChanged: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          widget.selectedServiceIds.add(service['id']);
                        } else {
                          widget.selectedServiceIds.remove(service['id']);
                        }
                      });
                    },
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}