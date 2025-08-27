
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';

import '../../../../Bloc/cubit/Forum/AnswerCubit.dart';
import '../../../../Bloc/cubit/Forum/general Bloc.dart';
import '../../../../Bloc/states/Forum/general state.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import 'Comments_page.dart';
import 'likes.dart';

class ForumPage extends StatefulWidget {
  final String courseName;
  final String token;
  final int sectionId;
  final int idTrainer;

  const ForumPage({
    Key? key,
    required this.courseName,
    required this.token,
    required this.sectionId,
    required this.idTrainer,
  }) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ForumCubit>().fetchSectionQuestions(
      // token: widget.token,
      sectionId: widget.sectionId,
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          padding: EdgeInsets.all(16.w),
          width: 600.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.translate("write_something") ?? 'Write something...',
                  filled: true,
                  fillColor: AppColors.highlightPurple,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    final txt = _controller.text.trim();
                    if (txt.isEmpty) return;
                    context.read<ForumCubit>().createQuestion(
                      // token: widget.token,
                      content: txt,
                      sectionId: widget.sectionId,
                    );
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.translate("create") ?? 'Create',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForumCubit, ForumState>(
      listener: (ctx, state) {

        if (state is QuestionCreated ||
            state is QuestionUpdated ||
            state is QuestionDeleted ||
            state is QuestionLiked ||
            state is QuestionUnliked) {
          ctx.read<ForumCubit>().fetchSectionQuestions(
            // token: widget.token,
            sectionId: widget.sectionId,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            const AppSidebar(selectedItem: SidebarItem.courses),
            Expanded(
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: 56.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black12.withOpacity(.06))),
                      ),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.translate("forum") ?? 'Forum',
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
                                  widget.courseName,
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.t3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Text(
                    //   AppLocalizations.of(context)?.translate("forum") ?? 'Forum',
                    //   style: TextStyle(
                    //       fontSize: 28.sp,
                    //       fontWeight: FontWeight.bold,
                    //       color: AppColors.darkBlue),
                    // ),

                    SizedBox(height: 50.h),

                    GestureDetector(
                      onTap: _showCreateDialog,
                      child: Container(
                        height: 70.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)?.translate("write_something") ?? 'Write something...',
                          style:
                          TextStyle(fontSize: 14.sp, color: AppColors.t3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Expanded(
                      child: BlocBuilder<ForumCubit, ForumState>(
                        builder: (ctx, state) {
                          if (state is ForumLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is ForumError) {
                            return Center(child: Text(state.message));
                          }
                          if (state is SectionQuestionsLoaded) {
                            final questions = state.page.data;
                            if (questions.isEmpty) {
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
                                      AppLocalizations.of(context)?.translate("nothing_to_display") ?? 'Nothing to display at this time',
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
                            return ListView.builder(
                              itemCount: questions.length,
                              itemBuilder: (_, i) {
                                final q = questions[i];

                                final postAvatar =
                                '$BASE_URL${q.user.photo}'.trim();
                                return Card(
                                  margin:
                                  EdgeInsets.symmetric(vertical: 8.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.r)),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 24.r,
                                            //   backgroundImage:
                                            //   NetworkImage(postAvatar),
                                            // ),
                                            CircleAvatar(
                                              radius: 24.r,
                                              child: ClipOval(

                                                child: postAvatar != null
                                                    ? ImageNetwork(
                                                  image: postAvatar,
                                                  width: 30,
                                                  height: 30,
                                                  fitAndroidIos: BoxFit.cover,
                                                )
                                                    : Icon(Icons.person, size: 50),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  q.user.name,
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  '${q.createdAt.hour.toString().padLeft(2,'0')}:${q.createdAt.minute.toString().padLeft(2,'0')}',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: AppColors.t2),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),

                                        Text(
                                          q.content,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppColors.darkBlue),
                                        ),
                                        SizedBox(height: 12.h),

                                        Row(
                                          children: [

                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => BlocProvider(
                                                      create: (_) => AnswerCubit(),
                                                      child: CommentsPage(
                                                        questionId: q.id,
                                                        token: widget.token,
                                                        trainerId: widget.idTrainer, sectionId: widget.sectionId,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.chat_bubble_outline, size: 20.sp, color: AppColors.t3),
                                                  SizedBox(width: 4.w),
                                                  Text('${q.answers.length}', style: TextStyle(color: AppColors.t3)),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 24.w),

                                            GestureDetector(
                                              onTap: () {
                                                final meId = widget.idTrainer;
                                                final liked = q.likes.any(
                                                        (l) =>
                                                    l.userId == meId);
                                                if (liked) {
                                                  ctx
                                                      .read<ForumCubit>()
                                                      .unlikeQuestion(
                                                    // token:
                                                    // widget.token,
                                                    questionId: q.id,
                                                  );
                                                } else {
                                                  ctx
                                                      .read<ForumCubit>()
                                                      .likeQuestion(
                                                    // token:
                                                    // widget.token,
                                                    questionId: q.id,
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                q.likes.any((l) =>
                                                l.userId ==
                                                    widget.idTrainer)
                                                    ? Icons.favorite
                                                    : Icons
                                                    .favorite_outline,
                                                color: AppColors.orange,
                                                size: 20.sp,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            // Text(
                                            //   '${q.likes.length}',
                                            //   style: TextStyle(
                                            //       color: AppColors.orange),
                                            // ),
                                            GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => LikesPage(
                                                  likes: q.likes.map((l) => User(
                                                    name: l.user.name,
                                                    avatar: '$BASE_URL${l.user.photo}'.trim(),
                                                  )).toList(),
                                                )),
                                              ),
                                              child: Text('${q.likes.length}', style: TextStyle(color: AppColors.orange)),
                                            ),
                                            Spacer(),

                                            if (q.userId == widget.idTrainer)
                                              IconButton(
                                                icon: Icon(Icons.edit,
                                                    color:
                                                    AppColors.orange),
                                                onPressed: () {
                                                  final ctrl =
                                                  TextEditingController(
                                                      text: q.content);
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        AlertDialog(
                                                          title:
                                                          Text(AppLocalizations.of(context)?.translate("edit_question") ?? 'Edit Question'),
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
                                                              Text(AppLocalizations.of(context)?.translate("cancel") ?? 'Cancel'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                final newContent =
                                                                ctrl.text
                                                                    .trim();
                                                                if (newContent
                                                                    .isNotEmpty) {
                                                                  context
                                                                      .read<
                                                                      ForumCubit>()
                                                                      .updateQuestion(
                                                                    // token: widget
                                                                    //     .token,
                                                                    questionId:
                                                                    q.id,
                                                                    content:
                                                                    newContent,
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                              child: Text(AppLocalizations.of(context)?.translate("save") ?? 'Save'),
                                                            ),
                                                          ],
                                                        ),
                                                  );
                                                },
                                              ),
                                            if (q.userId == widget.idTrainer)
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              AppLocalizations.of(context)?.translate("delete_question") ?? 'Delete Question'),
                                                          content: Text(
                                                              AppLocalizations.of(context)?.translate("delete_question_confirm") ?? 'Are you sure you want to delete this question?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(AppLocalizations.of(context)?.translate("no") ?? 'No'),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                  backgroundColor:
                                                                  Colors
                                                                      .red),
                                                              onPressed: () {
                                                                context
                                                                    .read<
                                                                    ForumCubit>()
                                                                    .deleteQuestion(
                                                                  // token:widget.token,
                                                                  questionId:
                                                                  q.id,
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(AppLocalizations.of(context)?.translate("yes") ?? 'Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    );
  }
}






