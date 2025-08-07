//
//
// import 'package:flutter/material.dart';
// import 'package:trainer_section/main.dart';
//
// class Language extends ChangeNotifier {
//   String _lang = language;
//   getLang() {
//     return _lang;
//   }
//   setLang(String lang) {
//     _lang = lang;
//     notifyListeners();
//   }
//
//
// //profileUser  Widget:
//   String switchLang() {
//     if (getLang() == 'Arabic') {
//       return "اللغة";
//     }
//     return 'language';
//   }
//   String editProfile() {
//     if (getLang() == 'Arabic') {
//       return "تعديل الملف الشخصي";
//     }
//     return 'Edit profile';
//   }
//   String Logout() {
//     if (getLang() == 'Arabic') {
//       return "تسجيل خروج";
//     }
//     return 'Logout';
//   }
//
//   String shared() {
//     if (getLang() == 'Arabic') {
//       return "عندما قمت بمشاركة المنتج";
//     }
//     return 'When you shared product';
//   }
//   String appear() {
//     if (getLang() == 'Arabic') {
//       return "سوف تظهر في ملفك الخاص بك.";
//     }
//     return 'they \'ll appear on your profile.';
//   }
//   String first() {
//     if (getLang() == 'Arabic') {
//       return "شارك منتجك الأول الآن!";
//     }
//     return 'Share your first product now!';
//   }
//
//
//
//   //Login:
//
//
//   String email() {
//     if (getLang() == 'Arabic') {
//       return " البريد الإلكتروني ";
//     }
//     return 'Email';
//   }
//   String Noemail() {
//     if (getLang() == 'Arabic') {
//       return " لا يمكن أن يكون البريد الإلكتروني فارغًا ";
//     }
//     return 'email can not be empty';
//   }
//   String password() {
//     if (getLang() == 'Arabic') {
//       return "كلمة المرور ";
//     }
//     return 'Password';
//   }
//   String Nopassword() {
//     if (getLang() == 'Arabic') {
//       return "لا يمكن أن تكون كلمة المرور فارغة ";
//     }
//     return 'password can not be empty ';
//   }
//   String Login() {
//     if (getLang() == 'Arabic') {
//       return " تسجيل الدخول";
//     }
//     return 'Login';
//   }
//
//
//   String Signup() {
//     if (getLang() == 'Arabic') {
//       return " اشتراك";
//     }
//     return 'signup';
//   }
//
//
//   //SignUp:
//   String FullName() {
//     if (getLang() == 'Arabic') {
//       return " أدخل اسمك الكامل ";
//     }
//     return 'Enter your full  name';
//   }
//   String UserName() {
//     if (getLang() == 'Arabic') {
//       return " أدخل اسم المستخدم ";
//     }
//     return 'Enter your user name  ';
//   }
//   String NotEmpty() {
//     if (getLang() == 'Arabic') {
//       return "لايمكن ان يكون فارغا";
//     }
//     return ' can not be empty';
//   }
//
//   String Next() {
//     if (getLang() == 'Arabic') {
//       return "  التالي ";
//     }
//     return 'Next';
//   }
//
//
//
//   //Ckeck code:
//   String EnterCode() {
//     if (getLang() == 'Arabic') {
//       return "ادخل رمزك ";
//     }
//     return 'Enter your code';
//   }
//
//
//   //reset Password:
//   String NoPassword() {
//     if (getLang() == 'Arabic') {
//       return "لا يمكن أن تكون كلمة المرور فارغة ";
//     }
//     return 'password can not be empty';
//   }
//   String ReWritePassword() {
//     if (getLang() == 'Arabic') {
//       return "أعد كتابة كلمة المرور الخاصة بك ";
//     }
//     return 'Re_write your password';
//   }
//
//   //LogOut:
//   String Sure() {
//     if (getLang() == 'Arabic') {
//       return "هل أنت متأكد؟ ";
//     }
//     return 'Are you sure?';
//   }
//   String LogOut() {
//     if (getLang() == 'Arabic') {
//       return "تسجيل الخروج";
//     }
//     return 'Log out';
//   }
//
//
//   //Dasvhboard
//   String CreateNewGroup() {
//     if (getLang() == 'Arabic') {
//       return "انشاء حساب جديد";
//     }
//     return 'Create New Group';
//   }
//
//   String Invitations() {
//     if (getLang() == 'Arabic') {
//       return " الدعوات";
//     }
//     return 'Invitations';
//   }
//
//   String Groups() {
//     if (getLang() == 'Arabic') {
//       return "المجموعات";
//     }
//     return 'Groups';
//   }
//
//   String Search() {
//     if (getLang() == 'Arabic') {
//       return "البحث";
//     }
//     return 'Search';
//   }
//
//   String SearchForUser() {
//     if (getLang() == 'Arabic') {
//       return " البحث عن مستخدم";
//     }
//     return 'Search For User';
//   }
//
//   String Setting() {
//     if (getLang() == 'Arabic') {
//       return "الاعدادات";
//     }
//     return 'Setting';
//   }
//
//   String Toggle() {
//     if (getLang() == 'Arabic') {
//       return "التبديل بين الوضع النهاري والليلي";
//     }
//     return 'toggle light/dark Mode';
//   }
//
//   String NoGroupsToDisplay() {
//     if (getLang() == 'Arabic') {
//       return "لا يوجد غروبات لعرضها";
//     }
//     return 'No Groups To Display';
//   }
//
//
//
// //groupDetails
//
//   String AddFile() {
//     if (getLang() == 'Arabic') {
//       return "اضافة ملف";
//     }
//     return 'Add File';
//   }
//   String Add() {
//     if (getLang() == 'Arabic') {
//       return "اضافة";
//     }
//     return 'Add ';
//   }
//
//   String Operation() {
//     if (getLang() == 'Arabic') {
//       return "العملية";
//     }
//     return 'Operation ';
//   }
//
//   String Date() {
//     if (getLang() == 'Arabic') {
//       return "التاريخ";
//     }
//     return 'Date ';
//   }
//
//   String FileName() {
//     if (getLang() == 'Arabic') {
//       return "اسم الملف";
//     }
//     return 'File Name ';
//   }
//   String FileHistory() {
//     if (getLang() == 'Arabic') {
//       return "سجل الملف";
//     }
//     return 'File History ';
//   }
//   String UserHistory() {
//     if (getLang() == 'Arabic') {
//       return "سجل المستخدم";
//     }
//     return 'User History ';
//   }
//   String GroupUsers() {
//     if (getLang() == 'Arabic') {
//       return "اعضاء الغروب";
//     }
//     return 'Group Users ';
//   }
//   String GroupName() {
//     if (getLang() == 'Arabic') {
//       return "اسم الغروب";
//     }
//     return 'Group Name ';
//   }
//   String GroupDescription() {
//     if (getLang() == 'Arabic') {
//       return "وصف الغروب";
//     }
//     return 'Group Description ';
//   }
//   String Create() {
//     if (getLang() == 'Arabic') {
//       return "انشاء ";
//     }
//     return 'Create  ';
//   }
//   String UsersNotInGroup() {
//     if (getLang() == 'Arabic') {
//       return "قم بدعوة الأشخاص!";
//     }
//     return 'Invite People! ';
//   }
//
//   String ChoiceFile() {
//     if (getLang() == 'Arabic') {
//       return "اختر ملف";
//     }
//     return 'Choice File';
//   }
//   String NoFilesToDisplay() {
//     if (getLang() == 'Arabic') {
//       return "لا يوجد فايلات لعرضها";
//     }
//     return 'No Files To Display';
//   }
//
//   String ShowUsers() {
//     if (getLang() == 'Arabic') {
//       return "عرض المستخدمين";
//     }
//     return 'Show Users';
//   }
//
//   String InviteUsers() {
//     if (getLang() == 'Arabic') {
//       return "ارسل دعوة";
//     }
//     return 'Invite Users';
//   }
//
//   //update
//   String UpdateGroup() {
//     if (getLang() == 'Arabic') {
//       return "تعديل الغروب";
//     }
//     return 'Update Group';
//   }
//
//   String Update() {
//     if (getLang() == 'Arabic') {
//       return "تعديل";
//     }
//     return 'Update file';
//   }
//
//   String EditFile() {
//     if (getLang() == 'Arabic') {
//       return "تعديل ملف";
//     }
//     return 'Update file';
//   }
//
//   String UploadNewFile() {
//     if (getLang() == 'Arabic') {
//       return "قم بتحميل ملف جديد";
//     }
//     return 'Upload New File';
//   }
//
//   //invitations
//
//   String Invite() {
//     if (getLang() == 'Arabic') {
//       return "ارسل دعوة";
//     }
//     return 'Invite Users';
//   }
//
//   String Cancel() {
//     if (getLang() == 'Arabic') {
//       return "الغاء";
//     }
//     return 'Cancel';
//   }
//
//
//   String Close() {
//     if (getLang() == 'Arabic') {
//       return " اغلاق";
//     }
//     return 'Close';
//   }
//
//   String NoInvitation() {
//     if (getLang() == 'Arabic') {
//       return " ليس لديك دعوات";
//     }
//     return 'You have No Invitaton';
//   }
//
//   String Save() {
//     if (getLang() == 'Arabic') {
//       return "حفظ";
//     }
//     return 'Save';
//   }
//
//   String FileSuccess() {
//     if (getLang() == 'Arabic') {
//       return "تم اضافة الملف بنجاح";
//     }
//     return 'File added successfully';
//   }
//   String FileSelect() {
//     if (getLang() == 'Arabic') {
//       return "اضف الملف اولا";
//     }
//     return '  Please select a file first!';
//   }
//
//   String FileSuccessUpdate() {
//     if (getLang() == 'Arabic') {
//       return "تم تعديل الملف بنجاح";
//     }
//     return 'File updated successfully';
//   }
//
//
//
//   String NoFileselected() {
//     if (getLang() == 'Arabic') {
//       return " لم تقم بتحديد ملف";
//     }
//     return 'No File selected:';
//   }
//
//   String Fileselected() {
//     if (getLang() == 'Arabic') {
//       return "تم تحديد الملف";
//     }
//     return 'File selected:';
//   }
//
//   String Arabic() {
//     if (getLang() == 'Arabic') {
//       return "العربية";
//     }
//     return 'Arabic';
//   }
//
//   String English() {
//     if (getLang() == 'Arabic') {
//       return "الانجليزية";
//     }
//     return 'English';
//   }
//
//   String languagee() {
//     if (getLang() == 'Arabic') {
//       return "اللغة";
//     }
//     return 'language';
//   }
//   String ChangeLanguage() {
//     if (getLang() == 'Arabic') {
//       return "تغير اللغة";
//     }
//     return 'Change Language';
//   }
//
//
//
// }
//
//
