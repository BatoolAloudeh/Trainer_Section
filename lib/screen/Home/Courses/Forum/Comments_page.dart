
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Bloc/cubit/Forum/AnswerCubit.dart';
import '../../../../Bloc/states/Forum/AnswerState.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';

import 'package:trainer_section/screen/Home/Courses/Forum/Comments_tile.dart';
import 'likes.dart';

class CommentsPage extends StatefulWidget {
  final int questionId;
  final String token;
  final int trainerId;
  final int sectionId;

  const CommentsPage({
    Key? key,
    required this.questionId,
    required this.token,
    required this.trainerId,
    required this.sectionId,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _controller = TextEditingController();
  String _sortMethod = 'Oldest';

  @override
  void initState() {
    super.initState();
    context.read<AnswerCubit>().fetchAnswers(
      // token: widget.token,
      questionId: widget.questionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          const AppSidebar(selectedItem: SidebarItem.courses),


          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Answers',
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue)),
                  SizedBox(height: 35.h),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Your answer...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: () {
                          final txt = _controller.text.trim();
                          if (txt.isNotEmpty) {
                            context.read<AnswerCubit>().createAnswer(
                              // token: widget.token,
                              questionId: widget.questionId,
                              content: txt,
                              courseSectionId: widget.sectionId,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text('Post', style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Sort by: ',
                          style: TextStyle(color: AppColors.t2)),
                      DropdownButton<String>(
                        value: _sortMethod,
                        underline: SizedBox(),
                        items: ['Oldest', 'Newest']
                            .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _sortMethod = v!),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),


                  Expanded(
                    child: BlocListener<AnswerCubit, AnswerState>(
                      listener: (ctx, state) {
                        if (state is AnswerCreated) _controller.clear();
                        if (state is AnswerCreated ||
                            state is AnswerUpdated ||
                            state is AnswerDeleted ||
                            state is AnswerLiked ||
                            state is AnswerUnliked ||
                            state is AnswerAccepted ||
                            state is AnswerUnaccepted) {
                          ctx.read<AnswerCubit>().fetchAnswers(
                            // token: widget.token,
                            questionId: widget.questionId,
                          );
                        }
                      },
                      child: BlocBuilder<AnswerCubit, AnswerState>(
                        builder: (ctx, state) {
                          if (state is AnswerLoading)
                            return Center(child: CircularProgressIndicator());
                          if (state is AnswerError)
                            return Center(child: Text(state.message));
                          if (state is AnswersLoaded) {
                            var answers = List.of(state.answers)
                              ..sort((a, b) => _sortMethod == 'Newest'
                                  ? b.createdAt.compareTo(a.createdAt)
                                  : a.createdAt.compareTo(b.createdAt));
                            if (answers.isEmpty)
                              return Center(child: Text('No answers yet'));

                            return ListView.builder(
                              itemCount: answers.length,
                              itemBuilder: (_, i) {
                                final a = answers[i];

                                final iLiked = a.likes.any(
                                        (l) => l.userId == widget.trainerId);

                                return CommentTile(
                                  comment: Comment(
                                    author: User(
                                      name: a.user.name,
                                      avatar:
                                      '$BASE_URL${a.user.photo}'.trim(),
                                    ),
                                    date: a.createdAt,
                                    content: a.content,
                                    likesCount: a.likesCount,
                                    isLiked: iLiked,
                                  ),
                                  onLikeTap: () {
                                    if (iLiked) {
                                      ctx.read<AnswerCubit>().unlikeAnswer(
                                        // token: widget.token,
                                        answerId: a.id,
                                      );
                                    } else {
                                      ctx.read<AnswerCubit>().likeAnswer(
                                        // token: widget.token,
                                        answerId: a.id,
                                      );
                                    }
                                  },
                                  onCountTap: () {
                                    final users = a.likes
                                        .map((l) => User(
                                      name: l.user.name,
                                      avatar:
                                      '$BASE_URL${l.user.photo}'
                                          .trim(),
                                    ))
                                        .toList();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LikesPage(likes: users),
                                      ),
                                    );
                                  },
                                  extraActions:
                                  a.userId == widget.trainerId
                                      ? Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          a.isAccepted
                                              ? Icons.check_circle
                                              : Icons
                                              .check_circle_outline,
                                          color: AppColors.orange,
                                          size: 20.sp,
                                        ),
                                        onPressed: () {
                                          if (a.isAccepted) {
                                            ctx
                                                .read<
                                                AnswerCubit>()
                                                .unacceptAnswer(
                                                // token:
                                                // widget
                                                //     .token,
                                                answerId:
                                                a.id);
                                          } else {
                                            ctx
                                                .read<
                                                AnswerCubit>()
                                                .acceptAnswer(
                                                // token:
                                                // widget
                                                //     .token,
                                                answerId:
                                                a.id);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color:
                                            AppColors.orange,
                                            size: 20.sp),
                                        onPressed: () {
                                          final ctrl =
                                          TextEditingController(
                                              text: a.content);
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                AlertDialog(
                                                  title:
                                                  Text('Edit Answer'),
                                                  content: TextField(
                                                    controller: ctrl,
                                                    maxLines: 3,
                                                    decoration:
                                                    InputDecoration(
                                                      border:
                                                      OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                      Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        final newC =
                                                        ctrl.text
                                                            .trim();
                                                        if (newC
                                                            .isNotEmpty) {
                                                          ctx
                                                              .read<
                                                              AnswerCubit>()
                                                              .updateAnswer(
                                                            // token: widget
                                                            //     .token,
                                                            answerId:
                                                            a.id,
                                                            content:
                                                            newC,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Text('Save'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red,
                                            size: 20.sp),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                AlertDialog(
                                                  title: Text(
                                                      'Delete Answer'),
                                                  content: Text(
                                                      'Are you sure?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                      Text('No'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          backgroundColor:
                                                          Colors
                                                              .red),
                                                      onPressed: () {
                                                        ctx
                                                            .read<
                                                            AnswerCubit>()
                                                            .deleteAnswer(
                                                          // token: widget
                                                          //     .token,
                                                          answerId:
                                                          a.id,
                                                        );
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child:
                                                      Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                      : null,
                                );
                              },
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
