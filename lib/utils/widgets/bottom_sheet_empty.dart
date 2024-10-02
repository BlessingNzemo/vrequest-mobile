import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odc_mobile_project/m_chat/ui/pages/ChatDetail/ChatDetailCtrl.dart';
import 'package:odc_mobile_project/m_course/business/Course.dart';
import 'package:odc_mobile_project/shared/ui/pages/shared/SharedCtrl.dart';
import 'package:odc_mobile_project/utils/size_config.dart';

class BottomSheetEmpty extends ConsumerStatefulWidget {
  BottomSheetEmpty({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetEmptyState();
}

class _BottomSheetEmptyState extends ConsumerState<BottomSheetEmpty> {

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    var block = AppSizes.screenWidth;
    var leftLayout = AppSizes.screenWidth / 3.5;
    var rightLayout = AppSizes.screenWidth / 1.5;

    return Container(
      color: Colors.white,
      width: AppSizes.screenWidth,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: Center(),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: Center(),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: Center(
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
