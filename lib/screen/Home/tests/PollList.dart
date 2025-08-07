import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';


class PollCard extends StatelessWidget {
  final Poll poll;
  final VoidCallback onDelete;
  const PollCard({
    Key? key,
    required this.poll,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poll.question,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontStyle: FontStyle.italic,
                  color: AppColors.t4)),
          SizedBox(height: 12.h),
          ...List.generate(poll.options.length, (i) {
            final isCorrect = i == poll.correctIndex;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCorrect
                            ? AppColors.orange
                            : AppColors.t2,
                        width: 2.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(poll.options[i],
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.t4)),
                ],
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete, color: AppColors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
