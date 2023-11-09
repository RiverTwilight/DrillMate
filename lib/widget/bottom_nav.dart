import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem {
  final IconData icon;
  final String title;

  CustomBottomNavigationBarItem({
    required this.icon,
    required this.title,
  });
}

class CustomBottomNavigationBar extends StatelessWidget {
  final List<CustomBottomNavigationBarItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              // Larger screen
              return SizedBox(
                width: 200,
                child: Column(
                  children: items.map((item) {
                    int index = items.indexOf(item);
                    return SizedBox(
                      height: 68, // set the height
                      width: double
                          .infinity, // set the width to take up all available space
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => onTap(index),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align the content to the start of the row
                          children: <Widget>[
                            const SizedBox(width: 20),
                            Container(
                              decoration: index == currentIndex
                                  ? BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(33),
                                    )
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add some padding to the icon
                                child: Icon(item.icon,
                                    color: index == currentIndex
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(
                              item.title,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              // Smaller screen
              return SizedBox(
                height: 76,
                child: Row(
                  children: items.map((item) {
                    int index = items.indexOf(item);
                    return Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () => onTap(index),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  decoration: index == currentIndex
                                      ? BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(33),
                                        )
                                      : null,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 5),
                                      Icon(item.icon,
                                          color: index == currentIndex
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(item.title),
                              ]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
