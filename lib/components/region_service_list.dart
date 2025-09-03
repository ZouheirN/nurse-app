import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intrinsic_size_builder/intrinsic_size_builder.dart';
import 'package:nurse_app/components/service_card.dart';
import 'package:nurse_app/features/services/models/get_services_model.dart';

class RegionServiceList extends StatefulWidget {
  final List<String> serviceNames;
  final List<int> serviceIds;
  final ValueNotifier<num?> selectedServiceId;
  final EdgeInsets padding;

  const RegionServiceList({
    super.key,
    required this.serviceNames,
    required this.serviceIds,
    required this.selectedServiceId,
    this.padding = const EdgeInsets.symmetric(horizontal: 40),
  });

  @override
  State<RegionServiceList> createState() => _RegionServiceListState();
}

class _RegionServiceListState extends State<RegionServiceList> {
  int selectedPage = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: selectedPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.serviceNames;

    return Column(
      children: [
        ExpandablePageView(
          controller: pageController,
          // physics: const NeverScrollableScrollPhysics(),
          // group each 9 services into a page, and create a new page if the services exceed 9, and handle index out of range
          children: List.generate(
            (services.length / 9).ceil(),
            (index) {
              final startIndex = index * 9;
              final endIndex = startIndex + 9;

              return _buildServicesPage(
                services.sublist(
                  startIndex,
                  endIndex > services.length ? services.length : endIndex,
                ),
                widget.serviceIds.sublist(
                  startIndex,
                  endIndex > widget.serviceIds.length
                      ? widget.serviceIds.length
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
        if (services.length > 9)
          // add numbered buttons to navigate between pages
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 5,
            children: List.generate(
              (services.length / 9).ceil(),
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
                        borderRadius: BorderRadius.circular(10),
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

  Widget _buildServicesPage(List<String> serviceNames, List<num> serviceIds) {
    return IntrinsicSizeBuilder(
      subject: Row(
        children: serviceNames.map((service) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  service,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      builder: (context, subjectSize, subject) {
        return Align(
          alignment: Alignment.topCenter,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 10,
              mainAxisExtent: subjectSize.height,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: widget.padding,
            children: serviceIds.map(
              (num serviceId) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.selectedServiceId.value == serviceId) {
                          widget.selectedServiceId.value = null;
                        } else {
                          widget.selectedServiceId.value = serviceId;
                        }
                      });
                    },
                    child: Container(
                      height: subjectSize.height,
                      width: MediaQuery.of(context).size.width * 0.24,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.selectedServiceId.value == serviceId
                              ? Colors.green
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          serviceNames[serviceIds.indexOf(serviceId)],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
