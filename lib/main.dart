import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
//import 'package:trattamento/models/chat%20bot/chat_model.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:trattamento/screens/auth_ui/login/login.dart';
import 'package:trattamento/screens/auth_ui/welcome/welcome.dart';
//import 'package:trattamento/screens/chat%20screen/Messages.dart';
import 'screens/chat screen/Messages.dart';
import 'package:trattamento/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'models/chat bot/chat_model.dart';

import 'constants/theme.dart';
import 'firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseConfig.platformOptions,
  );
runApp (const MyApp());
}
class MyApp extends StatelessWidget {
const MyApp({super.key});
@override
 Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'trattamento',
        theme: themeData,
        home: StreamBuilder(
          stream: FirebaseAuthHelper.instance.getAuthChange,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
             return const CustomBottomBar();
            }
            return const Welcome();
          },
        ),
      ),
    );
  }
}

