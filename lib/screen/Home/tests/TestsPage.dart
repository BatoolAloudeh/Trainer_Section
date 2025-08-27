// lib/screens/tests/TestsPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/screen/Home/tests/QuizDetailsPage.dart';

import '../../../Bloc/cubit/tests/GetQuizzesBySectionId.dart';
import '../../../Bloc/cubit/tests/delete_quiz.dart';
import '../../../Bloc/cubit/tests/delete_quiz_question.dart';
import '../../../Bloc/cubit/tests/update_quiz_question.dart';
import '../../../Bloc/cubit/tests/update_quiz_title.dart';
import '../../../Bloc/states/tests/GetQuizzesBySectionId.dart';
import '../../../Bloc/states/tests/operation.dart';
import '../../../localization/app_localizations.dart';

import '../../../models/tests/GetQuizzesBySectionId.dart';
import '../../../models/tests/quiz_title_update.dart';
import '../../../models/tests/quiz_question_update.dart';
import '../../../models/tests/quiz_option_update.dart';
import '../../../constant/ui/Colors/colors.dart';
import 'CreatePoll.dart';


class TestsPage extends StatelessWidget {
  final String courseName;
  final int sectionId;
  final String token;

  const TestsPage({
    Key? key,
    required this.courseName,
    required this.sectionId,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListQuizzesCubit()),
        BlocProvider(create: (_) => UpdateQuizTitleCubit()),
        BlocProvider(create: (_) => DeleteQuizCubit()),
        BlocProvider(create: (_) => UpdateQuizQuestionCubit()),
        BlocProvider(create: (_) => DeleteQuizQuestionCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UpdateQuizTitleCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<UpdateQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: _TestsView(
          courseName: courseName,
          sectionId: sectionId,
          token: token,
        ),
      ),
    );
  }
}

class _TestsView extends StatelessWidget {
  final String courseName;
  final int sectionId;
  final String token;

  const _TestsView({
    Key? key,
    required this.courseName,
    required this.sectionId,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
    final tr = AppLocalizations.of(context)?.translate;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            tr?.call("your_quizzes") ?? "Your Quizzes",
            style: TextStyle(
              fontSize: 20.sp,
              fontStyle: FontStyle.italic,
              color: AppColors.t2,
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: BlocBuilder<ListQuizzesCubit, ListQuizzesState>(
              builder: (ctx, state) {
                if (state is ListQuizzesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ListQuizzesError) {
                  return Center(child: Text(state.message));
                }
                if (state is ListQuizzesLoaded) {
                  final List<QuizItem> allQuizzes = state.response.quizzes.data;
                  if (allQuizzes.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // استخدم ارتفاع بدل العرض ليتناسب مع مساحة الشاشة العمودية
                            SizedBox(
                              height: 160.h,
                              child: Image.asset(
                                'assets/Images/no notification.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              tr?.call("nothing_to_display") ?? 'Nothing to display at this time',

                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );

                  }

                  final quizzes = allQuizzes.take(3).toList(); // ← أول ثلاثة فقط

                  return ListView.separated(
                    itemCount: quizzes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (_, idx) {
                      final quiz = quizzes[idx];
                      final QuizQuestionDetail? firstQ = quiz.questions.isNotEmpty ? quiz.questions.first : null;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  quiz.title,
                                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // تعديل العنوان
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColors.orange),
                                onPressed: () async {
                                  final newTitle = await showDialog<String>(
                                    context: context,
                                    builder: (_) => _TitleEditDialog(initial: quiz.title),
                                  );
                                  if (newTitle != null && newTitle.trim().isNotEmpty) {
                                    context.read<UpdateQuizTitleCubit>().updateTitle(
                                      token: token,
                                      quizId: quiz.id,
                                      data: QuizTitleUpdate(title: newTitle.trim()),
                                    );
                                  }
                                },
                              ),
                              // حذف الكويز
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(tr?.call("delete_quiz_q") ?? 'Delete quiz?'),
                                      content: Text(
                                        tr?.call("delete_quiz_warning") ??
                                            'This will remove all its questions.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(tr?.call("cancel") ?? 'Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(tr?.call("delete") ?? 'Delete'),
                                        ),
                                      ],
                                    ),
                                  ).then((confirm) {
                                    if (confirm == true) {
                                      context.read<DeleteQuizCubit>().deleteQuiz(
                                        token: token,
                                        quizId: quiz.id,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),

                          // عرض أول سؤال فقط + خياراته (تحرير/حذف للسؤال الأول فقط هنا)
                          children: [
                            if (firstQ != null)
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                color: AppColors.w1,
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              firstQ.question,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit, size: 20.sp, color: AppColors.orange),
                                            onPressed: () async {
                                              final updated = await showDialog<QuizQuestionUpdate>(
                                                context: context,
                                                builder: (_) => _QuestionEditDialog(initial: firstQ),
                                              );
                                              if (updated != null) {
                                                context.read<UpdateQuizQuestionCubit>().updateQuestion(
                                                  token: token,
                                                  questionId: firstQ.id,
                                                  data: updated,
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, size: 20.sp, color: Colors.red),
                                            onPressed: () {
                                              showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: Text(tr?.call("delete_question_q") ?? 'Delete question?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: Text(tr?.call("cancel") ?? 'Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: Text(tr?.call("delete") ?? 'Delete'),
                                                    ),
                                                  ],
                                                ),
                                              ).then((ok) {
                                                if (ok == true) {
                                                  context.read<DeleteQuizQuestionCubit>().deleteQuestion(
                                                    token: token,
                                                    questionId: firstQ.id,
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      ...firstQ.options.map((opt) => Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        child: Row(
                                          children: [
                                            Icon(
                                              opt.isCorrect ? Icons.star : Icons.radio_button_unchecked,
                                              size: 16.sp,
                                              color: opt.isCorrect ? AppColors.orange : Colors.grey,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                opt.option,
                                                style: TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // شريط سفلي: زر See all + زر إنشاء كويز
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final changed = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllQuizzesPage(
                          sectionId: sectionId,
                          token: token,
                          courseName: courseName,
                        ),
                      ),
                    );
                    if (changed == true) {
                      // إعادة التحميل بعد أي تعديل حقيقي في صفحة الكل
                      context.read<ListQuizzesCubit>().fetchQuizzesBySection(
                        token: token,
                        sectionId: sectionId,
                      );
                    }
                  },
                  icon: const Icon(Icons.list_alt_rounded),
                  label: Text(AppLocalizations.of(context)?.translate('see_more') ?? 'See all'),
                ),
                const Spacer(),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final bool? created = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => CreateQuizPage(
                          sectionId: sectionId,
                          token: token,
                          CourseName: courseName,
                        ),
                      ),
                    );

                    if (created == true) {
                      context.read<ListQuizzesCubit>().fetchQuizzesBySection(token: token, sectionId: sectionId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)?.translate("quiz_created_success") ?? 'Quiz created successfully!'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.add_chart, size: 18.sp, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)?.translate("create_quiz") ?? 'Create Quiz',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  backgroundColor: AppColors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleEditDialog extends StatelessWidget {
  final String initial;
  const _TitleEditDialog({Key? key, required this.initial}) : super(key: key);

  @override
  Widget build(BuildContext c) {
    final ctrl = TextEditingController(text: initial);
    final tr = AppLocalizations.of(c)?.translate;
    return AlertDialog(
      title: Text(tr?.call("edit_quiz_title") ?? 'Edit Quiz Title'),
      content: TextField(controller: ctrl),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(tr?.call("cancel") ?? 'Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: Text(tr?.call("save") ?? 'Save')),
      ],
    );
  }
}

class _QuestionEditDialog extends StatefulWidget {
  final QuizQuestionDetail initial;
  const _QuestionEditDialog({Key? key, required this.initial}) : super(key: key);

  @override
  State<_QuestionEditDialog> createState() => _QuestionEditDialogState();
}

class _QuestionEditDialogState extends State<_QuestionEditDialog> {
  late TextEditingController _qCtrl;
  late List<TextEditingController> _optCtrls;
  int? _correct;

  @override
  void initState() {
    super.initState();
    _qCtrl = TextEditingController(text: widget.initial.question);
    _optCtrls = widget.initial.options.map((o) => TextEditingController(text: o.option)).toList();
    _correct = widget.initial.options.indexWhere((o) => o.isCorrect);
  }

  @override
  Widget build(BuildContext c) {
    final tr = AppLocalizations.of(c)?.translate;
    return AlertDialog(
      title: Text(tr?.call("edit_question") ?? 'Edit Question'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _qCtrl,
              decoration: InputDecoration(
                labelText: tr?.call("question") ?? 'Question',
              ),
            ),
            SizedBox(height: 12.h),
            for (var i = 0; i < _optCtrls.length; i++)
              Row(
                children: [
                  Radio<int>(value: i, groupValue: _correct, onChanged: (v) => setState(() => _correct = v)),
                  Expanded(child: TextField(controller: _optCtrls[i])),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(tr?.call("cancel") ?? 'Cancel')),
        TextButton(
          onPressed: () {
            final opts = <QuizOptionUpdate>[];
            for (var i = 0; i < widget.initial.options.length; i++) {
              opts.add(QuizOptionUpdate(
                id: widget.initial.options[i].id,
                option: _optCtrls[i].text.trim(),
                isCorrect: i == _correct,
              ));
            }
            Navigator.pop(
              c,
              QuizQuestionUpdate(
                question: _qCtrl.text.trim(),
                options: opts,
              ),
            );
          },
          child: Text(tr?.call("save") ?? 'Save'),
        ),
      ],
    );
  }
}

