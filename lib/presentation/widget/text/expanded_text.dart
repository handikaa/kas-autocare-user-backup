import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _readMore = false;
  late String firstPart;
  late String secondPart;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 150) {
      firstPart = widget.text.substring(0, 150);
      secondPart = widget.text.substring(150, widget.text.length);
    } else {
      firstPart = widget.text;
      secondPart = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondPart.isEmpty
        ? Text(widget.text, style: widget.style)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _readMore ? (firstPart + secondPart) : (firstPart + "..."),
                style: widget.style,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _readMore = !_readMore;
                  });
                },
                child: Text(
                  _readMore ? "Tutup" : "Baca selengkapnya",
                  style: TextStyle(
                    color: AppColors.light.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
  }
}
