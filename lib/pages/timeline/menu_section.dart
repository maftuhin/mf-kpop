import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpop_lyrics/models/m_menu.dart';
import 'package:line_icons/line_icons.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            MMenu(
              menu: "Most Viewed",
              path: "/most-viewed",
              icon: LineIcons.trophy,
            ),
            MMenu(
              menu: "Request",
              path: "/request",
              icon: LineIcons.alternateCloudUpload,
            ),
          ]
              .map((e) => InkWell(
                    onTap: () {
                      context.push(e.path ?? "/");
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Expanded(child: Icon(e.icon)),
                          Text(
                            e.menu ?? "",
                            maxLines: 1,
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
