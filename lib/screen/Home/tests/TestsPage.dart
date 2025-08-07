//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:trainer_section/screen/Home/tests/CreatePoll.dart';
// import '../../../Bloc/cubit/tests/GetQuizzesBySectionId.dart';
// import '../../../Bloc/states/tests/GetQuizzesBySectionId.dart';
// import '../../../constant/ui/Colors/colors.dart';
//
//
// class TestsPage extends StatelessWidget {
//   final String courseName;
//   final int sectionId;
//   final String token;
//
//   const TestsPage({
//     Key? key,
//     required this.courseName,
//     required this.sectionId,
//     required this.token,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // اجلب الاختبارات عند الدخول
//     context.read<ListQuizzesCubit>()
//         .fetchQuizzesBySection(token: token, sectionId: sectionId);
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           SizedBox(height: 20.h),
//           Text('Your Quizzes',
//               style: TextStyle(
//                   fontSize: 20.sp,
//                   fontStyle: FontStyle.italic,
//                   color: AppColors.t2)),
//           SizedBox(height: 24.h),
//
//           // ─── قائمة الاختبارات ─────────────────
//           Expanded(
//             child: BlocBuilder<ListQuizzesCubit, ListQuizzesState>(
//               builder: (ctx, state) {
//                 if (state is ListQuizzesLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is ListQuizzesError) {
//                   return Center(child: Text(state.message));
//                 }
//                 if (state is ListQuizzesLoaded) {
//                   final quizzes = state.response.quizzes.data;
//                   if (quizzes.isEmpty) {
//                     return Center(child: Text('No quizzes found'));
//                   }
//                   return ListView.separated(
//                     itemCount: quizzes.length,
//                     separatorBuilder: (_, __) => SizedBox(height: 16.h),
//                     itemBuilder: (_, idx) {
//                       final quiz = quizzes[idx];
//                       return Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r)),
//                         child: ExpansionTile(
//                           title: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   quiz.title,
//                                   style: TextStyle(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit, color: AppColors.orange),
//                                 onPressed: () {
//                                   // TODO: implement edit-quiz
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   // TODO: implement delete-quiz
//                                 },
//                               ),
//                             ],
//                           ),
//                           children: [
//                             // لكل سؤال: صندوق منفصل
//                             for (var q in quiz.questions) ...[
//                               Card(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 16.w, vertical: 8.h),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.r)),
//                                 color: AppColors.w1,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(12.w),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       // سؤال + أزرار تعديل/حذف
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               q.question,
//                                               style: TextStyle(
//                                                   fontSize: 16.sp,
//                                                   fontWeight:
//                                                   FontWeight.w600),
//                                             ),
//                                           ),
//                                           IconButton(
//                                             icon: Icon(Icons.edit,
//                                                 size: 20.sp,
//                                                 color: AppColors.orange),
//                                             onPressed: () {
//                                               // TODO: edit-question
//                                             },
//                                           ),
//                                           IconButton(
//                                             icon: Icon(Icons.delete,
//                                                 size: 20.sp, color: Colors.red),
//                                             onPressed: () {
//                                               // TODO: delete-question
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 8.h),
//                                       // خيارات السؤال مع نجمة للخيار الصحيح
//                                       for (var opt in q.options) ...[
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               opt.isCorrect
//                                                   ? Icons.star
//                                                   : Icons
//                                                   .radio_button_unchecked,
//                                               size: 16.sp,
//                                               color: opt.isCorrect
//                                                   ? AppColors.orange
//                                                   : Colors.grey,
//                                             ),
//                                             SizedBox(width: 8.w),
//                                             Expanded(
//                                               child: Text(
//                                                 opt.option,
//                                                 style: TextStyle(
//                                                     fontSize: 14.sp),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 6.h),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//
//           // ─── زر إنشاء اختبار جديد ────────────
//           Align(
//             alignment: Alignment.bottomRight,
//             child: FloatingActionButton.extended(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => CreateQuizPage(
//                       sectionId: sectionId,
//                       token: token,
//                     ),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.add_chart, size: 18.sp, color: Colors.white),
//               label: Text('Create Quiz',
//                   style: TextStyle(fontSize: 12.sp, color: Colors.white)),
//               backgroundColor: AppColors.purple,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.r)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







// lib/screen/Home/tests/TestsPage.dart

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
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>()
                    .fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>()
                    .fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<UpdateQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>()
                    .fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<DeleteQuizQuestionCubit, QuizOperationState>(
            listener: (ctx, state) {
              if (state is QuizOperationSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                ctx.read<ListQuizzesCubit>()
                    .fetchQuizzesBySection(token: token, sectionId: sectionId);
              } else if (state is QuizOperationFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
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

    context.read<ListQuizzesCubit>()
        .fetchQuizzesBySection(token: token, sectionId: sectionId);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Your Quizzes',
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
                  final quizzes = state.response.quizzes.data;
                  if (quizzes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/Images/no notification.png',
                            width: 200.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'No Quizzes Found',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.orange,
                            ),
                          ),

                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: quizzes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (_, idx) {
                      final quiz = quizzes[idx];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  quiz.title,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // ── edit quiz title ──
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColors.orange),
                                onPressed: () async {
                                  final newTitle = await showDialog<String>(
                                    context: context,
                                    builder: (_) => _TitleEditDialog(initial: quiz.title),
                                  );
                                  if (newTitle != null) {
                                    context.read<UpdateQuizTitleCubit>().updateTitle(
                                      token: token,
                                      quizId: quiz.id,
                                      data: QuizTitleUpdate(title: newTitle),
                                    );
                                  }
                                },
                              ),

                              // ── delete entire quiz ──
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Delete quiz?'),
                                      content: Text('This will remove all its questions.'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
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
                          children: [
                            for (var q in quiz.questions) ...[
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                color: AppColors.w1,
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ── question + edit/delete ──
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              q.question,
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
                                                builder: (_) => _QuestionEditDialog(
                                                  initial: q,
                                                ),
                                              );
                                              if (updated != null) {
                                                context.read<UpdateQuizQuestionCubit>().updateQuestion(
                                                  token: token,
                                                  questionId: q.id,
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
                                                  title: Text('Delete question?'),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                                                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                                                  ],
                                                ),
                                              ).then((ok) {
                                                if (ok == true) {
                                                  context.read<DeleteQuizQuestionCubit>().deleteQuestion(
                                                    token: token,
                                                    questionId: q.id,
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 8.h),

                                      // ── options with star for correct ──
                                      for (var opt in q.options) ...[
                                        Row(
                                          children: [
                                            Icon(
                                              opt.isCorrect ? Icons.star : Icons.radio_button_unchecked,
                                              size: 16.sp,
                                              color: opt.isCorrect ? AppColors.orange : Colors.grey,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(child: Text(opt.option, style: TextStyle(fontSize: 14.sp))),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
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

          // ── create new quiz button ──
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              // onPressed: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (_) => CreateQuizPage(
              //         sectionId: sectionId,
              //         token: token, CourseName: courseName,
              //       ),
              //     ),
              //   );
              // },




              onPressed: () async {


                final bool? created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => CreateQuizPage(
                      sectionId:  sectionId,
                      token:      token,
                      CourseName: courseName,
                    ),
                  ),
                );


                if (created == true) {
                  context.read<ListQuizzesCubit>()
                      .fetchQuizzesBySection(token: token, sectionId: sectionId);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quiz created successfully!'))
                  );
                }
              },



              icon: Icon(Icons.add_chart, size: 18.sp, color: Colors.white),
              label: Text('Create Quiz', style: TextStyle(fontSize: 12.sp, color: Colors.white)),
              backgroundColor: AppColors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
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
    return AlertDialog(
      title: Text('Edit Quiz Title'),
      content: TextField(controller: ctrl),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: Text('Save')),
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
    return AlertDialog(
      title: Text('Edit Question'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _qCtrl, decoration: InputDecoration(labelText: 'Question')),
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
        TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel')),
        TextButton(onPressed: () {
          final opts = <QuizOptionUpdate>[];
          for (var i = 0; i < widget.initial.options.length; i++) {
            opts.add(QuizOptionUpdate(
              id: widget.initial.options[i].id,
              option: _optCtrls[i].text.trim(),
              isCorrect: i == _correct,
            ));
          }
          Navigator.pop(c, QuizQuestionUpdate(
            question: _qCtrl.text.trim(),
            options: opts,
          ));
        }, child: Text('Save')),
      ],
    );
  }
}
