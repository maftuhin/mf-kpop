import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLyric extends StatelessWidget {
  const ShimmerLyric({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Text(
            "Loading Please Wait",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      bottomNavigationBar: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: const ListTile(
          leading: Icon(LineIcons.music),
          title: Text("Loading..."),
          subtitle: Text("Load data from server."),
        ),
      ),
    );
  }
}
