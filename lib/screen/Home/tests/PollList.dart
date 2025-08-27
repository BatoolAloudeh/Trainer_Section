
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/ui/Colors/colors.dart';

class Poll {
  final String question;
  final List<String> options;
  final int correctIndex;
  const Poll({required this.question, required this.options, required this.correctIndex});
}

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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + زر حذف
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  poll.question,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              Tooltip(
                message: 'Delete',
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          ...List.generate(poll.options.length, (i) {
            final isCorrect = i == poll.correctIndex;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                    size: 18.sp,
                    color: isCorrect ? AppColors.orange : AppColors.t3,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      poll.options[i],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.t4,
                        fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
