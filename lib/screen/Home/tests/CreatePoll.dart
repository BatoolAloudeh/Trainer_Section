
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trainer_section/screen/Auth/Login.dart';
import 'package:trainer_section/screen/Home/Courses/Details/MainCourseDetails.dart';
import 'package:trainer_section/screen/Home/tests/TestsPage.dart';

import '../../../Bloc/cubit/tests/create test.dart';
import '../../../Bloc/states/tests/create test.dart';
import '../../../models/tests/create test.dart';
import '../../../constant/ui/Colors/colors.dart';
import '../../../constant/ui/General constant/ConstantUi.dart';


class CreateQuizPage extends StatefulWidget {
  final int    sectionId;
  final String token;
  final String CourseName;

  const CreateQuizPage({
    Key? key,
    required this.sectionId,
    required this.token,
    required this.CourseName

  }) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleCtrl = TextEditingController();
  final List<_QuestionForm> _forms = [];

  @override
  void initState() {
    super.initState();
    _addQuestion();
  }

  void _addQuestion()   => setState(() => _forms.add(_QuestionForm()));
  void _removeQuestion(int i) => setState(() => _forms.removeAt(i));

  bool get _canSubmit {
    if (_titleCtrl.text.trim().isEmpty) return false;
    for (var f in _forms) if (!f.isValid) return false;
    return true;
  }

  Future<void> _submit() async {
    final questions = _forms.map((f) {
      final opts = f.optionCtrls.asMap().entries.map((e) {
        return QuizOption(
          option:   e.value.text.trim(),
          isCorrect: e.key == f.correctIndex,
        );
      }).toList();
      return QuizQuestion(
        question: f.questionCtrl.text.trim(),
        options:  opts,
      );
    }).toList();

    final quiz = Quiz(
      title:           _titleCtrl.text.trim(),
      courseSectionId: widget.sectionId,
      questions:       questions,
    );

    await context.read<QuizCubit>().createQuiz(
      token: widget.token,
      quiz:  quiz,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
    );

    return BlocProvider(
      create: (_) => QuizCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(35.w),
                child: Column(
                  children: [
                    // العنوان
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quizzes',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),],),
                    SizedBox(height: 40.h),




                    TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Quiz Title',

                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 12.h),


                    Expanded(
                      child: ListView.builder(
                        itemCount: _forms.length,
                        itemBuilder: (_, i) => _QuestionCard(
                          form:      _forms[i],
                          index:     i+1,
                          onRemove:  _forms.length>1 ? ()=>_removeQuestion(i) : null,
                          onChanged: ()=>setState((){}),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),


                    ElevatedButton.icon(
                      icon:  const Icon(Icons.add, size: 18),
                      label: const Text('Add Question'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        minimumSize: Size(400, 55.h),
                      ),
                      onPressed: _addQuestion,
                    ),
                    SizedBox(height: 30.h),


                    // BlocConsumer<QuizCubit, QuizState>(
                    //   listener: (ctx, state) {
                    //     if (state is QuizSuccess) {
                    //
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Quiz created successfully!'))
                    //       );
                    //
                    //
                    //     }
                    //     if (state is QuizFailure) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text(state.error))
                    //       );
                    //     }
                    //   },
                    //   builder: (ctx, state) {
                    //     if (state is QuizLoading) {
                    //       return const Center(child: CircularProgressIndicator());
                    //     }
                    //     return ElevatedButton(
                    //       onPressed: _canSubmit ? _submit : null,
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.orange,
                    //         minimumSize: Size(400, 48.h),
                    //       ),
                    //       child: const Text('Create Quiz'),
                    //     );
                    //   },
                    // ),





                    BlocConsumer<QuizCubit, QuizState>(
                      listener: (ctx, state) {
                        if (state is QuizSuccess) {
                          debugPrint('✅ QuizSuccess – Pop true');

                          if (mounted) Navigator.of(ctx).pop(true);
                        }
                        if (state is QuizFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error))
                          );
                        }
                      },
                      builder: (ctx, state) {
                        if (state is QuizLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: _canSubmit ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            minimumSize: Size(400, 48.h),
                          ),
                          child: const Text('Create Quiz'),
                        );
                      },
                    ),







                    SizedBox(height: 16.h),
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

class _QuestionForm {
  final questionCtrl = TextEditingController();
  final optionCtrls  = <TextEditingController>[];
  int? correctIndex;

  _QuestionForm() {
    optionCtrls.add(TextEditingController());
    optionCtrls.add(TextEditingController());
  }

  bool get isValid {
    if (questionCtrl.text.trim().isEmpty) return false;
    if (optionCtrls.length < 2) return false;
    if (correctIndex == null) return false;
    for (var c in optionCtrls) if (c.text.trim().isEmpty) return false;
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${widget.index}',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),

            SizedBox(height: 8.h),


            TextField(
              controller: f.questionCtrl,
              decoration: const InputDecoration(
                hintText: 'Enter question',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => widget.onChanged?.call(),
            ),
            SizedBox(height: 12.h),


            for (var i = 0; i < f.optionCtrls.length; i++) ...[
              Row(
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
                        hintText: 'Option ${i+1}',
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => widget.onChanged?.call(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.orange),
                    onPressed: () {
                      setState(() => f.removeOption(i));
                      widget.onChanged?.call();
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],

            // زر إضافة خيار
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: Icon(Icons.add, color: AppColors.purple),
                label: Text('Add Option', style: TextStyle(color: AppColors.purple)),
                onPressed: () {
                  setState(() => f.addOption());
                  widget.onChanged?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
