// ignore_for_file: sort_child_properties_last

// import 'package:book_basket/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/utils/colors.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final bool? disabled;
  final bool? isLoading;
  final double? widthSize;

  final String? subText;
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.disabled,
    this.isLoading,
    this.widthSize,
    this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    // return ScreenUtilInit(builder: () {
    return ElevatedButton(
      onPressed: disabled == true || isLoading == true ? () {} : onPressed,
      child: SizedBox(
        width: widthSize ?? mediaquery.width * (0.3),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                  isLoading == true
                      ? Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 15,
                          height: 15,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.5,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              subText != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subText.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      style: disabled == false
          ? ElevatedButton.styleFrom(
              backgroundColor: MyColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(14),
              elevation: 0,
            )
          : ElevatedButton.styleFrom(
              backgroundColor: MyColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)), disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
              padding: const EdgeInsets.all(14),
              elevation: 0,
              textStyle: const TextStyle(color: Colors.white)),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final bool? disabled;
  final bool? isLoading;
  final double? widthSize;

  final String? subText;
  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.disabled,
    this.isLoading,
    this.widthSize,
    this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    // return ScreenUtilInit(builder: () {
    return ElevatedButton(
      onPressed: disabled == true || isLoading == true ? () {} : onPressed,
      child: SizedBox(
        width: widthSize ?? mediaquery.width * (0.6),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                  isLoading == true
                      ? Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 15,
                          height: 15,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.5,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              subText != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subText.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      style: disabled == false
          ? ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff9CA9B8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.all(14),
              elevation: 0,
            )
          : ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff9CA9B8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)), disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
              padding: const EdgeInsets.all(14),
              elevation: 0,
              textStyle: const TextStyle(color: Colors.white)),
    );
  }
}
