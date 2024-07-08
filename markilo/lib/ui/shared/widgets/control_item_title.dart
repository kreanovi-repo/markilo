import 'package:flutter/material.dart';
import 'package:markilo/ui/buttons/custom_outlined_button.dart';
import 'package:markilo/ui/labels/custom_labels.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ControlItemTitle extends StatelessWidget {
  const ControlItemTitle(
      {super.key, required this.title, required this.onPressed});

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            CustomOutlinedButton(
                text: 'Cancel'.tr(),
                color: Colors.red,
                hPadding: 3,
                vPadding: 3,
                fontSize: 12,
                isFilled: true,
                onPressed: () => onPressed()),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            title,
            style: CustomLabels.h2,
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
