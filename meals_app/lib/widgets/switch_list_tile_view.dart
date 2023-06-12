import 'package:flutter/material.dart';

class switchingTile extends StatefulWidget {
  const switchingTile(
      {super.key,
      required this.title,
      required this.subtitle,
       required this.filter });
  final String title;
  final String subtitle;
  final bool filter;

  @override
  State<switchingTile> createState() => _switchingTileState();
}

class _switchingTileState extends State<switchingTile> {
  late String title;
  late String subtitle;
 late bool filter;
 @override
  void initState() {
    super.initState();
    title = widget.title;
    subtitle = widget.subtitle;
    filter = widget.filter;
  }
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: filter,
      onChanged: (isChecked) {
        setState(() {
          filter = isChecked;
        });
      },
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
