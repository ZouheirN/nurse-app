import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/main.dart';

import '../../components/region_service_list.dart';
import '../../components/services_list.dart';
import '../../features/areas/cubit/areas_cubit.dart';
import '../../features/services/cubit/services_cubit.dart';

class RegionPricingPage extends StatefulWidget {
  final int areaId;

  const RegionPricingPage({super.key, required this.areaId});

  @override
  State<RegionPricingPage> createState() => _RegionPricingPageState();
}

class _RegionPricingPageState extends State<RegionPricingPage> {
  final _areasCubit = AreasCubit();
  final _areasCubitBtn = AreasCubit();
  final _servicesCubit = ServicesCubit();
  ValueNotifier<num?> selectedService = ValueNotifier(null);

  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _servicesCubit.fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Region Pricing'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              BlocBuilder<ServicesCubit, ServicesState>(
                bloc: _servicesCubit,
                builder: (context, state) {
                  if (state is ServicesFetchLoading) {
                    return const Loader();
                  } else if (state is ServicesFetchSuccess) {
                    final services = state.services;

                    return RegionServiceList(
                      serviceNames:
                          services.services.map((e) => e.name!).toList(),
                      serviceIds: services.services.map((e) => e.id!).toList(),
                      selectedServiceId: selectedService,
                    );
                    // return ServicesList(
                    //   services: services,
                    //   selectedServiceIds: selectedServiceIds,
                    // );
                  } else {
                    return const Text('Failed to fetch services.');
                  }
                },
              ),
              // BlocBuilder<AreasCubit, AreasState>(
              //   bloc: _areasCubit,
              //   builder: (context, state) {
              //     if (state is GetServiceAreaPricesLoading) {
              //       return const Loader();
              //     } else if (state is GetServiceAreaPricesFailure) {
              //       return Text('Error: ${state.message}');
              //     } else if (state is GetServiceAreaPricesSuccess) {
              //       final serviceAreaPrices =
              //           state.serviceAreaPrices.serviceAreaPrices;
              //
              //       final servicesInArea = serviceAreaPrices
              //           .where((sap) => sap.areaId == widget.areaId)
              //           .toList();
              //
              //       List<String> serviceNames = [];
              //       List<String> serviceIds = [];
              //
              //       for (int i = 0; i < servicesInArea.length; i++) {
              //         final service = servicesInArea[i];
              //
              //         serviceNames.add(service.service!.name.toString());
              //         serviceIds.add(service.serviceId.toString());
              //       }
              //
              //       return RegionServiceList(
              //         serviceNames: serviceNames,
              //         serviceIds: serviceIds.map(int.parse).toList(),
              //         selectedServiceId: selectedService,
              //       );
              //     } else {
              //       return const Text('Failed to fetch services.');
              //     }
              //   },
              // ),
              const SizedBox(height: 20),
              ValueListenableBuilder<num?>(
                valueListenable: selectedService,
                builder: (context, value, child) {
                  if (value != null) {
                    return BlocBuilder<AreasCubit, AreasState>(
                      bloc: _areasCubit..getServiceAreaPricesForService(value),
                      builder: (context, state) {
                        if (state is GetServiceAreaPricesForServiceLoading) {
                          return const Loader();
                        } else if (state
                            is GetServiceAreaPricesForServiceFailure) {
                          return Text('Error: ${state.message}');
                        } else if (state
                            is GetServiceAreaPricesForServiceSuccess) {
                          final serviceAreaPrices =
                              state.serviceAreaPrices.areaPrices;

                          // filter only the prices for the selected area
                          final filteredAreaPrices = serviceAreaPrices.where(
                            (sap) => sap.areaId == widget.areaId,
                          );

                          final priceForThisService =
                              filteredAreaPrices.isNotEmpty
                                  ? filteredAreaPrices.first.price
                                  : null;

                          if (priceForThisService != null) {
                            _priceController.text =
                                priceForThisService.toString();
                          } else {
                            _priceController.clear();
                          }

                          return Column(
                            children: [
                              MyTextField(
                                controller: _priceController,
                                hintText: 'Set Price (\$)',
                                inputType: TextInputType.number,
                                icon: const Icon(Icons.price_change),
                                obscureText: false,
                              ),
                              const SizedBox(height: 20),
                              BlocConsumer<AreasCubit, AreasState>(
                                bloc: _areasCubitBtn,
                                listener: (context, state) {
                                  if (state is AddServiceAreaPriceSuccess ||
                                      state is EditServiceAreaPriceSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Price set successfully.')),
                                    );
                                    // Optionally, refresh the prices
                                    _areasCubit
                                        .getServiceAreaPricesForService(value);
                                  } else if (state
                                      is AddServiceAreaPriceFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  } else if (state
                                      is EditServiceAreaPriceFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading =
                                      state is AddServiceAreaPriceLoading ||
                                          state is EditServiceAreaPriceLoading;

                                  return MyThirdButton(
                                    isLoading: isLoading,
                                    onTap: () {
                                      final price =
                                          num.tryParse(_priceController.text);

                                      if (price != null) {
                                        if (priceForThisService == null) {
                                          _areasCubitBtn.addServiceAreaPrice(
                                            serviceId: value.toInt(),
                                            areaId: widget.areaId,
                                            price: price.toDouble(),
                                          );
                                        } else {
                                          _areasCubitBtn.editServiceAreaPrice(
                                            servicePriceId:
                                                filteredAreaPrices.first.id!,
                                            price: price.toDouble(),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please enter a valid price.')),
                                        );
                                      }
                                    },
                                    buttonText: 'Set Pricing',
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const Text('Failed to fetch pricing.');
                        }
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
