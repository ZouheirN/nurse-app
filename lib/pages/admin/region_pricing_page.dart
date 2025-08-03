import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';

import '../../features/areas/cubit/areas_cubit.dart';

class RegionPricingPage extends StatefulWidget {
  const RegionPricingPage({super.key});

  @override
  State<RegionPricingPage> createState() => _RegionPricingPageState();
}

class _RegionPricingPageState extends State<RegionPricingPage> {
  final _areasCubit = AreasCubit();

  @override
  void initState() {
    _areasCubit.getServiceAreaPrices();
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
          child: BlocBuilder<AreasCubit, AreasState>(
            bloc: _areasCubit,
            builder: (context, state) {
              if (state is GetServiceAreaPricesLoading) {
                return const Loader();
              }

              if (state is GetServiceAreaPricesFailure) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is GetServiceAreaPricesSuccess) {
                final areas = state.serviceAreaPrices.serviceAreaPrices;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: areas.length,
                        itemBuilder: (context, index) {
                          final area = areas[index];

                          return ListTile(
                            title: Text(area.area!.name.toString()),
                            subtitle: Text('Price: ${area.price}'),
                          );
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/manageRegionPricing');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Region Pricing'),
                    ),
                  ],
                );
              }

              return const Center(child: Text('Failed to load areas.'));
            },
          ),
        ),
      ),
    );
  }
}
