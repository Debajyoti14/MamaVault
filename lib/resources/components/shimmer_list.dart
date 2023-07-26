// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:interrupt/resources/components/profile_shimmer.dart';
import 'package:interrupt/resources/components/text_shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int length;
  final EdgeInsets padding;
  const ShimmerList({
    Key? key,
    required this.length,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: const ProfileShimmer(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextShimmer(
                    height: 10,
                    width: size.width * 0.7,
                  ),
                  const SizedBox(height: 10),
                  TextShimmer(
                    height: 8,
                    width: size.width * 0.6,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
