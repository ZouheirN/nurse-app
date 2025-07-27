import 'package:flutter/material.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime? time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    this.time,
    this.onTap,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isRead ? Colors.transparent : const Color(0xFF7BB442),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                child: Image(
                  image: AssetImage('assets/images/square_logo.png'),
                  width: 60,
                  height: 60,
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.asset(
              //     'assets/images/dr.png',
              //     width: 60,
              //     height: 60,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(142, 142, 142, 1),
                        fontWeight: FontWeight.w400,
                      ),
                      // maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (time != null) ...[
                const SizedBox(width: 10),
                Text(
                  formatDateTimeForCard(time!),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
              // const SizedBox(width: 10),
              // const Icon(
              //   Icons.chevron_right,
              //   size: 20,
              //   color: Colors.black,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
