import 'package:flutter/material.dart';
import 'package:nurse_app/extensions/context_extension.dart';

import '../../components/filter_button.dart';
import '../../components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  final bool showLeading;

  const NotificationsPage({super.key, required this.showLeading});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final bool show = true;

  late List<String> _filterOptions;
  late String _selectedFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterOptions = [
      context.localizations.today,
      context.localizations.thisWeek,
      context.localizations.lastMonth,
      context.localizations.all,
    ];
    _selectedFilter = context.localizations.today;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.showLeading
            ? IconButton(
                icon: const Icon(Icons.chevron_left,
                    size: 48, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          context.localizations.notifications,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/images/header_background.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 243, 253, 233),
      body: !show
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/notification3.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'No Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final filter in _filterOptions)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FilterButton(
                            filterText: filter,
                            isSelected: _selectedFilter == filter,
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: NotificationCard(
                          title: 'Notification Title',
                          description: 'Notification Details',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
