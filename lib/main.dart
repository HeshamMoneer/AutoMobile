import 'dart:convert';

import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/routes/route.dart';
import 'package:AutoMobile/src/screens/navBarScreeen.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool staySignedIn = false;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  if (message.data != {}) {
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.black,
          ),
        ),
        payload: jsonEncode(message.data));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  staySignedIn = prefs.getBool('staySignedIn') ?? false;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    getToken();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_logo_white_svg');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        var messageData = jsonDecode(details.payload ?? "{}");
        print(messageData);
        if (messageData['type'] == 'chat') {
          BuildContext? myContext = navigatorKey.currentState?.context;
          var allProvider = Provider.of<AllProvider>(myContext!, listen: false);
          allProvider.getUserById(messageData['senderId']).then(
            (user) {
              Navigator.pushNamed(
                myContext,
                '/inbox/chat',
                arguments: user,
              );
            },
          );
        } else if (messageData['type'] == 'bid') {
          BuildContext? myContext = navigatorKey.currentState?.context;
          Navigator.of(myContext!).pushNamed('/listingDetail',
              arguments: {'listingId': messageData['listingId'] as String});
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      String? currentRoute;
      navigatorKey.currentState?.popUntil((route) {
        currentRoute = route.settings.name;
        return true;
      });

      bool dontShowNotification = message.data['type'] == 'chat' &&
          (currentRoute!.contains('chat') ||
              NavBarScreenState.selectedTabIndex == 1);

      if (message.data != {} && !dontShowNotification) {
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.data['title'],
            message.data['body'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.black,
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    var allProvider = AllProvider();
    print(token);
    return ChangeNotifierProvider(
      create: (ctx) => allProvider,
      child: MaterialApp(
        title: 'AutoMobile',
        theme: AppTheme.lightTheme,
        initialRoute: allProvider.getCurrentUserId() == "" || !staySignedIn
            ? '/login'
            : '/mainscreen',
        routes: Routes.getRoutes(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
