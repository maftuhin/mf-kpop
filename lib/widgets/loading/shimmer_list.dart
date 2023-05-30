import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int? length;
  const ShimmerList({
    Key? key,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: const ListTile(
            leading: Icon(FluentIcons.circle_12_regular),
            title: Icon(FluentIcons.square_12_regular),  
          ),
        );
      },
      itemCount: length,
    );
  }
}
