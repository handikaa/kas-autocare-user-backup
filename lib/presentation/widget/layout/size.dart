import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveDouble on double {
  double get rwidth => w; // ex: 20.rwidth
  double get rheight => h; // ex: 20.rheight
  double get rsp => sp; // ex: 14.rsp (font size)
}
