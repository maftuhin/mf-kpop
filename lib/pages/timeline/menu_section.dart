import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
              icon: FluentIcons.trophy_16_regular,
            ),
            MMenu(
              menu: "Request",
              path: "/request",
              icon: FluentIcons.mail_add_16_regular,
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
