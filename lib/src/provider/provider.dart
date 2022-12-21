import 'package:AutoMobile/src/database/firebasehandler.dart';
import 'package:flutter/foundation.dart';

class AllProvider with ChangeNotifier {
  FireBaseHandler db = FireBaseHandler();
}
