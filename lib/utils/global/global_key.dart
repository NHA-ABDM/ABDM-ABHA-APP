import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>(); // for navigation tracker
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(); // to use for drawer or bottom navigation
GlobalKey<ScaffoldMessengerState> scaffoldMsgKey = GlobalKey<ScaffoldMessengerState>(); // for snackbar msg
// GlobalKey<FormState> formKey = GlobalKey<FormState>(); // for form in formtextview tracker
