import 'shimmer.dart';
import 'package:flutter/material.dart';

class ChatUserSkeleton extends StatelessWidget {
  const ChatUserSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Row(
        children: [
          const ShimmerCircle(
            size: 80,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Shimmer(),
                const SizedBox(height: 8),
                const Shimmer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
