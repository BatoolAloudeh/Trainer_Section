import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Bloc/cubit/tests/create test.dart';
import '../../../Bloc/states/tests/create test.dart';
import '../../../localization/app_localizations.dart';
import '../../../models/tests/create test.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';
import 'package:trainer_section/screen/Home/Courses/Details/MainCourseDetails.dart';

class CreateQuizPage extends StatefulWidget {
  final int sectionId;
  final String token;
  final String CourseName;
  final int idTrainer;
  final String time;
  final String day;

  const CreateQuizPage({
    Key? key,
    required this.sectionId,
    required this.token,
    required this.CourseName,
    required this.idTrainer,
    required this.time,
    required this.day,
  }) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleCtrl = TextEditingController();
  final List<_QuestionForm> _forms = [];

  // ✅ استخدم نسخة واحدة من الكيوبت عبر الصفحة كلها
  late final QuizCubit _quizCubit;

  @override
  void initState() {
    super.initState();
    _quizCubit = QuizCubit();       // ← نسخة واحدة
    _addQuestion();
  }

  @override
  void dispose() {
    _quizCubit.close();
    _titleCtrl.dispose();
    for (final q in _forms) {
      q.questionCtrl.dispose();
      for (final o in q.optionCtrls) {
        o.dispose();
      }
    }
    super.dispose();
  }

  void _addQuestion() => setState(() => _forms.add(_QuestionForm()));
  void _removeQuestion(int i) => setState(() => _forms.removeAt(i));

  bool get _canSubmit {
    if (_titleCtrl.text.trim().isEmpty) return false;
    for (var f in _forms) {
      if (!f.isValid) return false;
    }
    return true;
  }

  Future<void> _submit() async {
    final questions = _forms.map((f) {
      final opts = f.optionCtrls.asMap().entries.map((e) {
        return QuizOption(
          option: e.value.text.trim(),
          isCorrect: e.key == f.correctIndex,
        );
      }).toList();
      return QuizQuestion(
        question: f.questionCtrl.text.trim(),
        options: opts,
      );
    }).toList();

    final quiz = Quiz(
      title: _titleCtrl.text.trim(),
      courseSectionId: widget.sectionId,
      questions: questions,
    );

    // ✅ استخدم نفس النسخة المزوّدة في BlocProvider.value
    await _quizCubit.createQuiz(token: widget.token, quiz: quiz);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);
    final tr = AppLocalizations.of(context)?.translate;

    return BlocProvider.value(
      // ✅ نمرّر نفس النسخة (بدون إنشاء جديد)
      value: _quizCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    // ===== شريط علوي =====
                    Container(
                      height: 56.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black12.withOpacity(.06))),
                      ),
                      child: Row(
                        children: [
                          Text(
                            tr?.call("quizzes") ?? "Quizzes",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(.10),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: AppColors.purple.withOpacity(.25)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.menu_book, size: 14, color: Colors.deepPurple),
                                SizedBox(width: 6.w),
                                Text(
                                  widget.CourseName,
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.t3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ===== المحتوى =====
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 1100.w),
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: Colors.black12.withOpacity(.08)),
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
                            Text(
                              tr?.call("quiz_title") ?? "Quiz Title",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkBlue,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            TextField(
                              controller: _titleCtrl,
                              decoration: InputDecoration(
                                hintText: tr?.call("quiz_title") ?? "Quiz Title",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: Colors.black12.withOpacity(.25)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(color: AppColors.orange),
                                ),
                                fillColor: AppColors.w1,
                                filled: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),

                            SizedBox(height: 16.h),

                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 12.h),
                                itemCount: _forms.length,
                                itemBuilder: (_, i) => _QuestionCard(
                                  form: _forms[i],
                                  index: i + 1,
                                  onRemove: _forms.length > 1 ? () => _removeQuestion(i) : null,
                                  onChanged: () => setState(() {}),
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                FilledButton.icon(
                                  onPressed: _addQuestion,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                  ),
                                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                  label: Text(
                                    tr?.call("add_question") ?? "Add Question",
                                    style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
                                  ),
                                ),
                                const Spacer(),

                                BlocConsumer<QuizCubit, QuizState>(
                                  listener: (ctx, state) {
                                    if (state is QuizSuccess) {
                                      // ✅ تنقّل آمن بعد النجاح
                                      if (!mounted) return;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CourseDetailsPage(
                                            idTrainer: widget.idTrainer,
                                            sectionId: widget.sectionId,
                                            title: widget.CourseName,
                                            time: widget.time,
                                            day: widget.day,
                                            token: widget.token,
                                            // (اختياري) لو ضفت باراميتر initialTab في CourseDetailsPage:
                                            // initialTab: CourseDetailTab.quizzes,
                                          ),
                                        ),
                                      );
                                    }
                                    if (state is QuizFailure) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.error)),
                                      );
                                    }
                                  },
                                  builder: (ctx, state) {
                                    final isLoading = state is QuizLoading;
                                    return FilledButton(
                                      onPressed: (_canSubmit && !isLoading) ? _submit : null,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.orange,
                                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                        height: 20.r,
                                        width: 20.r,
                                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                          : Text(
                                        tr?.call("create_quiz") ?? "Create Quiz",
                                        style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== نموذج بيانات الفورم ===================== */

class _QuestionForm {
  final questionCtrl = TextEditingController();
  final optionCtrls = <TextEditingController>[];
  int? correctIndex;

  _QuestionForm() {
    optionCtrls.add(TextEditingController());
    optionCtrls.add(TextEditingController());
  }

  bool get isValid {
    if (questionCtrl.text.trim().isEmpty) return false;
    if (optionCtrls.length < 2) return false;
    if (correctIndex == null) return false;
    for (var c in optionCtrls) {
      if (c.text.trim().isEmpty) return false;
    }
    return true;
  }

  void addOption() {
    if (optionCtrls.length < 10) optionCtrls.add(TextEditingController());
  }

  void removeOption(int idx) {
    optionCtrls.removeAt(idx);
    if (correctIndex != null && correctIndex! >= optionCtrls.length) {
      correctIndex = null;
    }
  }
}

/* ===================== بطاقة السؤال ===================== */

class _QuestionCard extends StatefulWidget {
  final _QuestionForm form;
  final int index;
  final VoidCallback? onRemove;
  final VoidCallback? onChanged;

  const _QuestionCard({
    Key? key,
    required this.form,
    required this.index,
    this.onRemove,
    this.onChanged,
  }) : super(key: key);

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  @override
  Widget build(BuildContext context) {
    final f = widget.form;
    final tr = AppLocalizations.of(context)?.translate;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black12.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.orange.withOpacity(.35)),
                ),
                child: Text(
                  '${widget.index}',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              const Spacer(),
              if (widget.onRemove != null)
                IconButton(
                  tooltip: tr?.call("delete") ?? 'Delete',
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          SizedBox(height: 12.h),

          Text(
            tr?.call("question") ?? "Question",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.t3,
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            controller: f.questionCtrl,
            decoration: InputDecoration(
              hintText: tr?.call("enter_question") ?? "Enter question",
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.black12.withOpacity(.25)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.orange),
              ),
              fillColor: AppColors.w1,
              filled: true,
            ),
            onChanged: (_) => widget.onChanged?.call(),
          ),
          SizedBox(height: 14.h),

          Text(
            tr?.call("option") ?? "Option",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.t3,
            ),
          ),
          SizedBox(height: 8.h),

          for (var i = 0; i < f.optionCtrls.length; i++) ...[
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.w1,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.black12.withOpacity(.15)),
              ),
              child: Row(
                children: [
                  Radio<int>(
                    value: i,
                    groupValue: f.correctIndex,
                    activeColor: AppColors.orange,
                    onChanged: (v) {
                      setState(() => f.correctIndex = v);
                      widget.onChanged?.call();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: f.optionCtrls[i],
                      decoration: InputDecoration(
                        hintText: '${tr?.call("option") ?? "Option"} ${i + 1}',
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => widget.onChanged?.call(),
                    ),
                  ),
                  IconButton(
                    tooltip: tr?.call("delete") ?? 'Delete',
                    icon: Icon(Icons.close_rounded, color: AppColors.orange),
                    onPressed: () {
                      setState(() => f.removeOption(i));
                      widget.onChanged?.call();
                    },
                  ),
                ],
              ),
            ),
          ],

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() => f.addOption());
                widget.onChanged?.call();
              },
              icon: Icon(Icons.add_rounded, color: AppColors.purple),
              label: Text(
                tr?.call("add_option") ?? "Add Option",
                style: TextStyle(color: AppColors.purple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
