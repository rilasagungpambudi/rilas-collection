import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBars extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? customTitle;
  final Widget? leading;
  final bool? centerTitle;
  final bool? backBtn;
  final double height;
  final List<Widget>? actions;
  const AppBars(
      {super.key,
      required this.title,
      this.leading,
      this.centerTitle,
      this.customTitle,
      this.backBtn = false,
      this.height = kToolbarHeight,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      centerTitle: centerTitle,
      elevation: 1,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      leading: leading,
      backgroundColor: Colors.white,
      actions: actions,
      title: customTitle ??
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
