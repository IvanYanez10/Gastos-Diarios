import 'package:flutter/material.dart';

class FilterDrawer extends StatelessWidget {
  final Function() onApplyFilter;

  const FilterDrawer({Key? key, required this.onApplyFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: Text('Filter Options'),
            // Add filter options here
          ),
          ListTile(
            title: Text('Amount Slider'),
            // Add amount slider here
          ),
          ListTile(
            title: Text('Date Selector'),
            // Add date selector here
          ),
          ListTile(
            title: TextButton(
              onPressed: onApplyFilter,
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
