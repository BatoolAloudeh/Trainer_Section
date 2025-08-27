import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/cubit/Forum/AnswerCubit.dart';
import '../../../../Bloc/states/Forum/AnswerState.dart';
import '../../../../constant/constantKey/key.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import 'likes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/cubit/Forum/AnswerCubit.dart';
import '../../../../Bloc/states/Forum/AnswerState.dart';
import '../../../../constant/ui/Colors/colors.dart';
import '../../../../constant/ui/General constant/ConstantUi.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../constant/constantKey/key.dart';

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
  bool _canPost = false;

  @override
  void initState() {
    super.initState();
    context.read<AnswerCubit>().fetchAnswers(questionId: widget.questionId);
    _controller.addListener(() {
      final v = _controller.text.trim();
      if (_canPost != v.isNotEmpty) {
        setState(() => _canPost = v.isNotEmpty);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _post() {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    context.read<AnswerCubit>().createAnswer(
      questionId: widget.questionId,
      content: txt,
      courseSectionId: widget.sectionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tr = AppLocalizations.of(context)?.translate;

    // لضمان عمل .w و .h
    ScreenUtil.init(context, designSize: const Size(1440, 1024), minTextAdapt: true);

    return Scaffold(
      backgroundColor: t.scaffoldBackgroundColor,
      body: Row(
        children: [
          const AppSidebar(selectedItem: SidebarItem.courses),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header خفيف
                  Container(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12.withOpacity(.06))),
                    ),
                    child: Row(
                      children: [
                        Text(
                          tr?.call("answers") ?? 'Answers',
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
                                "Post",
                                style: TextStyle(fontSize: 12.sp, color: AppColors.t3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Composer بأسلوب فيسبوك (صورة + حقل + زر)
                  _Composer(
                    controller: _controller,
                    enabled: true,
                    canPost: _canPost,
                    onPost: _post,
                  ),

                  SizedBox(height: 16.h),

                  // Sort row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (tr?.call("sort_by") ?? 'Sort by') + ': ',
                        style: TextStyle(color: AppColors.t2),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: t.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: t.colorScheme.outlineVariant),
                        ),
                        child: DropdownButton<String>(
                          value: _sortMethod,
                          underline: const SizedBox(),
                          isDense: true,
                          items: ['Oldest', 'Newest']
                              .map(
                                (s) => DropdownMenuItem(
                              value: s,
                              child: Text(tr?.call(s) ?? s),
                            ),
                          )
                              .toList(),
                          onChanged: (v) => setState(() => _sortMethod = v!),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // List
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
                          ctx.read<AnswerCubit>().fetchAnswers(questionId: widget.questionId);
                        }
                      },
                      child: BlocBuilder<AnswerCubit, AnswerState>(
                        builder: (ctx, state) {
                          if (state is AnswerLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is AnswerError) {
                            return Center(child: Text(state.message));
                          }
                          if (state is AnswersLoaded) {
                            final answers = List.of(state.answers)
                              ..sort(
                                    (a, b) => _sortMethod == 'Newest'
                                    ? b.createdAt.compareTo(a.createdAt)
                                    : a.createdAt.compareTo(b.createdAt),
                              );

                            if (answers.isEmpty) {
                              return Center(
                                child: Text(
                                  tr?.call("no_answers") ?? 'No answers yet',
                                  style: t.textTheme.titleMedium,
                                ),
                              );
                            }

                            return ListView.separated(
                              padding: EdgeInsets.only(bottom: 8.h),
                              itemCount: answers.length,
                              separatorBuilder: (_, __) => SizedBox(height: 8.h),
                              itemBuilder: (_, i) {
                                final a = answers[i];
                                final iLiked = a.likes.any((l) => l.userId == widget.trainerId);

                                // ابنِ رابط الصورة للمعلّق
                                final avatarUrl = (a.user.photo != null &&
                                    a.user.photo.toString().trim().isNotEmpty)
                                    ? ('$BASE_URL${a.user.photo}'.trim())
                                    : '';
                                print("avatar:$avatarUrl");

                                return _FbCommentTile(
                                  name: a.user.name,
                                  avatarUrl: avatarUrl,
                                  content: a.content,
                                  dateTime: a.createdAt,
                                  likesCount: a.likesCount,
                                  isLiked: iLiked,
                                  // like/unlike
                                  onToggleLike: () {
                                    if (iLiked) {
                                      ctx.read<AnswerCubit>().unlikeAnswer(answerId: a.id);
                                    } else {
                                      ctx.read<AnswerCubit>().likeAnswer(answerId: a.id);
                                    }
                                  },
                                  // open likers
                                  onLikesTap: () {
                                    final users = a.likes
                                        .map(
                                          (l) => User(
                                        name: l.user.name,
                                        avatar: (l.user.photo != null &&
                                            l.user.photo.toString().trim().isNotEmpty)
                                            ? ('$BASE_URL${l.user.photo}'.trim())
                                            : '',
                                      ),
                                    )
                                        .toList();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LikesPage(likes: users),
                                      ),
                                    );
                                  },
                                  // owner actions (edit/delete/accept)
                                  trailingOwnerActions: a.userId == widget.trainerId
                                      ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: a.isAccepted
                                            ? (tr?.call("unaccept") ?? "Unaccept")
                                            : (tr?.call("accept") ?? "Accept"),
                                        icon: Icon(
                                          a.isAccepted
                                              ? Icons.check_circle
                                              : Icons.check_circle_outline,
                                          color: AppColors.orange,
                                          size: 20.sp,
                                        ),
                                        onPressed: () {
                                          if (a.isAccepted) {
                                            ctx.read<AnswerCubit>().unacceptAnswer(answerId: a.id);
                                          } else {
                                            ctx.read<AnswerCubit>().acceptAnswer(answerId: a.id);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        tooltip: tr?.call("edit_answer") ?? 'Edit Answer',
                                        icon: Icon(Icons.edit, color: AppColors.orange, size: 20.sp),
                                        onPressed: () {
                                          final ctrl = TextEditingController(text: a.content);
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Text(tr?.call("edit_answer") ?? 'Edit Answer'),
                                              content: TextField(
                                                controller: ctrl,
                                                maxLines: 4,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(tr?.call("cancel") ?? 'Cancel'),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    final newC = ctrl.text.trim();
                                                    if (newC.isNotEmpty) {
                                                      ctx
                                                          .read<AnswerCubit>()
                                                          .updateAnswer(answerId: a.id, content: newC);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(tr?.call("save") ?? 'Save'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        tooltip: tr?.call("delete") ?? 'Delete',
                                        icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Text(tr?.call("delete_answer") ?? 'Delete Answer'),
                                              content: Text(tr?.call("are_you_sure") ?? 'Are you sure?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(tr?.call("no") ?? 'No'),
                                                ),
                                                FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    ctx.read<AnswerCubit>().deleteAnswer(answerId: a.id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(tr?.call("yes") ?? 'Yes'),
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
                          return const SizedBox.shrink();
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

/* ================= UI Partials ================ */

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool canPost;
  final VoidCallback onPost;

  const _Composer({
    required this.controller,
    required this.enabled,
    required this.canPost,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tr = AppLocalizations.of(context)?.translate;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: t.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Avatar (بدون شبكة لأننا لا نملك رابط مؤكد هنا)
          CircleAvatar(
            radius: 20.r,
            backgroundColor: t.colorScheme.primary.withOpacity(.12),
            child: Icon(Icons.person, color: t.colorScheme.primary, size: 20.sp),
          ),
          SizedBox(width: 10.w),

          // Input
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) => onPost(),
              decoration: InputDecoration(
                hintText: tr?.call("your_answer") ?? 'Your answer...',
                filled: true,
                fillColor: t.colorScheme.surface,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: t.colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: t.colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: t.colorScheme.primary, width: 1.6),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Post
          FilledButton.icon(
            onPressed: canPost ? onPost : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              backgroundColor: AppColors.darkBlue,
              disabledBackgroundColor: AppColors.t3.withOpacity(.25),
            ),
            icon: const Icon(Icons.send, color: Colors.white),
            label: Text(
              tr?.call("post") ?? 'Post',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FbCommentTile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String content;
  final DateTime dateTime;
  final int likesCount;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onLikesTap;
  final Widget? trailingOwnerActions;

  const _FbCommentTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.content,
    required this.dateTime,
    required this.likesCount,
    required this.isLiked,
    required this.onToggleLike,
    required this.onLikesTap,
    this.trailingOwnerActions,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tr = AppLocalizations.of(context)?.translate;

    // تأكيد رابط الصورة (تجنّب "null" كنص)
    final String avatar = (avatarUrl).trim().toLowerCase() == 'null' ? '' : avatarUrl.trim();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: t.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          // CircleAvatar(
          //   radius: 18.r,
          //   backgroundColor: t.colorScheme.primary.withOpacity(.12),
          //   backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          //   child: avatar.isEmpty
          //       ? Icon(Icons.person, color: t.colorScheme.primary, size: 18.sp)
          //       : null,
          // ),
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.w1,
            child: ClipOval(
              child: avatarUrl != null
                  ? ImageNetwork(
                image: avatarUrl,
                width: 55.r,
                height: 55.r,
                fitAndroidIos: BoxFit.cover,
              )
                  : Icon(Icons.person, size: 80.r),
            ),
          ),
          SizedBox(width: 10.w),

          // Name + bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // فقاعة المحتوى
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: t.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBlue,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        content,
                        style: t.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),

                // Meta actions
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12.w,
                  runSpacing: 6.h,
                  children: [
                    GestureDetector(
                      onTap: onToggleLike,
                      child: Text(
                        isLiked ? (tr?.call("unlike") ?? "Unlike") : (tr?.call("like") ?? "Like"),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isLiked ? AppColors.orange : AppColors.t2,
                        ),
                      ),
                    ),
                    Text('·', style: TextStyle(color: AppColors.t3)),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(dateTime),
                      style: TextStyle(color: AppColors.t3),
                    ),
                    if (likesCount > 0) ...[
                      Text('·', style: TextStyle(color: AppColors.t3)),
                      InkWell(
                        onTap: onLikesTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: t.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined, size: 14),
                              SizedBox(width: 6.w),
                              Text('$likesCount'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Owner actions on the right
          if (trailingOwnerActions != null) ...[
            SizedBox(width: 6.w),
            trailingOwnerActions!,
          ],
        ],
      ),
    );
  }
}
