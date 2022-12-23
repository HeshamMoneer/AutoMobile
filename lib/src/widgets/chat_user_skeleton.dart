import 'shimmer.dart';
import 'package:flutter/material.dart';

class ChatUserSkeleton extends StatelessWidget {
  const ChatUserSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerCircle(
          size: 120,
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
    );
  }
}
