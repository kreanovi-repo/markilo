import 'package:flutter/material.dart';
import 'package:markilo/services/navigation_service.dart';
import 'package:markilo/ui/cards/white_card.dart';

class HomeShortcut extends StatelessWidget {
  const HomeShortcut({
    super.key,
    required this.title,
    required this.iconImage,
    required this.route,
    required this.subTitle,
  });

  final String title;
  final String iconImage;
  final String route;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    const double width = 180.0;
    const double widthImage = 80.0;
    const double height = 180.0;
    const double heightImage = 64.0;
    return SizedBox(
      width: width,
      height: height,
      child: WhiteCard(
          title: title,
          child: Column(
            children: [
              Image.asset(
                iconImage,
                width: widthImage,
                height: heightImage,
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                      foregroundColor: WidgetStateProperty.all(Colors.white)),
                  onPressed: () {
                    NavigationService.replaceTo(route);
                  },
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.center,
                  ))
            ],
          )),
    );
  }
}
