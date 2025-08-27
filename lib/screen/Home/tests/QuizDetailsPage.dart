// lib/screens/tests/AllQuizzesPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Bloc/cubit/tests/GetQuizzesBySectionId.dart';
import '../../../Bloc/cubit/tests/delete_quiz.dart';
import '../../../Bloc/cubit/tests/delete_quiz_question.dart';
import '../../../Bloc/cubit/tests/update_quiz_question.dart';
import '../../../Bloc/cubit/tests/update_quiz_title.dart';
import '../../../Bloc/states/tests/GetQuizzesBySectionId.dart';
import '../../../Bloc/states/tests/operation.dart';

import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';
import '../../../localization/app_localizations.dart';

import '../../../models/tests/GetQuizzesBySectionId.dart';
import '../../../models/tests/quiz_title_update.dart';
import '../../../models/tests/quiz_question_update.dart';
import '../../../models/tests/quiz_option_update.dart';

class AllQuizzesPage extends StatefulWidget {
  final int sectionId;
  final String token;
  final String courseName;

  const AllQuizzesPage({
    Key? key,
    required this.sectionId,
    required this.token,
    required this.courseName,
  }) : super(key: key);

  @override
  State<AllQuizzesPage> createState() => _AllQuizzesPageState();
}

class _AllQuizzesPageState extends State<AllQuizzesPage> {
  bool _dirty = false;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)?.translate;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListQuizzesCubit()..fetchQuizzesBySection(token: widget.token, sectionId: widget.sectionId)),
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
                _dirty = true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: widget.token, sectionId: widget.sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                _dirty = true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: widget.token, sectionId: widget.sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<UpdateQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                _dirty = true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: widget.token, sectionId: widget.sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                _dirty = true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>().fetchQuizzesBySection(token: widget.token, sectionId: widget.sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, _dirty);
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Row(
              children: [
                const AppSidebar(selectedItem: SidebarItem.courses),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // شريط علوي داخلي مع سهم الرجوع
                        Container(
                          height: 56.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black12.withOpacity(.06)),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: tr?.call('back') ?? 'Back',
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context, _dirty),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                tr?.call('your_quizzes') ?? 'Your Quizzes',
                                style: TextStyle(
                                  fontSize: 22.sp,
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
                                      widget.courseName,
                                      style: TextStyle(fontSize: 12.sp, color: AppColors.t3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

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
                                final quizzes = state.response.quizzes.data;
                                if (quizzes.isEmpty) {
                                  return Center(
                                    child: Text(
                                      tr?.call('no_quizzes_found') ?? 'No Quizzes Found',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  itemCount: quizzes.length,
                                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                  itemBuilder: (_, idx) {
                                    final quiz = quizzes[idx];

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
                                              tooltip: tr?.call("edit_quiz_title") ?? 'Edit Quiz Title',
                                              icon: Icon(Icons.edit, color: AppColors.orange),
                                              onPressed: () async {
                                                final newTitle = await showDialog<String>(
                                                  context: context,
                                                  builder: (_) => _TitleEditDialog(initial: quiz.title),
                                                );
                                                if (newTitle != null && newTitle.trim().isNotEmpty) {
                                                  ctx.read<UpdateQuizTitleCubit>().updateTitle(
                                                    token: widget.token,
                                                    quizId: quiz.id,
                                                    data: QuizTitleUpdate(title: newTitle.trim()),
                                                  );
                                                }
                                              },
                                            ),
                                            // حذف الكويز
                                            IconButton(
                                              tooltip: tr?.call("delete") ?? 'Delete',
                                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                                              onPressed: () async {
                                                final confirm = await showDialog<bool>(
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
                                                );
                                                if (confirm == true) {
                                                  ctx.read<DeleteQuizCubit>().deleteQuiz(
                                                    token: widget.token,
                                                    quizId: quiz.id,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                        // كل الأسئلة لهذا الكويز
                                        children: [
                                          if (quiz.questions.isEmpty)
                                            Padding(
                                              padding: EdgeInsets.all(12.w),
                                              child: Text(
                                                tr?.call('no_quizzes_found') ?? 'No Questions',
                                                style: TextStyle(
                                                  color: AppColors.t3,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 10.h),
                                              child: Column(
                                                children: quiz.questions.map((q) {
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      border: Border.all(color: Colors.black12.withOpacity(.08)),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(12.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  q.question,
                                                                  style: TextStyle(
                                                                    fontSize: 15.sp,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: AppColors.darkBlue,
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                tooltip: tr?.call("edit_question") ?? 'Edit Question',
                                                                icon: Icon(Icons.edit, size: 20.sp, color: AppColors.orange),
                                                                onPressed: () async {
                                                                  final updated = await showDialog<QuizQuestionUpdate>(
                                                                    context: context,
                                                                    builder: (_) => _QuestionEditDialog(initial: q),
                                                                  );
                                                                  if (updated != null) {
                                                                    ctx.read<UpdateQuizQuestionCubit>().updateQuestion(
                                                                      token: widget.token,
                                                                      questionId: q.id,
                                                                      data: updated,
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              IconButton(
                                                                tooltip: tr?.call("delete_question_q") ?? 'Delete question?',
                                                                icon: Icon(Icons.delete, size: 20.sp, color: Colors.red),
                                                                onPressed: () async {
                                                                  final ok = await showDialog<bool>(
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
                                                                  );
                                                                  if (ok == true) {
                                                                    ctx.read<DeleteQuizQuestionCubit>().deleteQuestion(
                                                                      token: widget.token,
                                                                      questionId: q.id,
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8.h),
                                                          ...q.options.map((opt) => Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 4.h),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  opt.isCorrect
                                                                      ? Icons.check_circle_rounded
                                                                      : Icons.radio_button_unchecked,
                                                                  size: 18.sp,
                                                                  color: opt.isCorrect ? AppColors.orange : AppColors.t3,
                                                                ),
                                                                SizedBox(width: 8.w),
                                                                Expanded(
                                                                  child: Text(
                                                                    opt.option,
                                                                    style: TextStyle(
                                                                      fontSize: 13.5.sp,
                                                                      color: AppColors.t4,
                                                                      fontWeight: opt.isCorrect
                                                                          ? FontWeight.w600
                                                                          : FontWeight.normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* === Dialogs المعاد استخدامها === */

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
