import 'dart:async';

import 'package:test_app/models/branch.dart';

class BranchList {
  static List<Branch> branchList = [];
  static Future<List<Branch>> getBranch() async {
    if (branchList.isEmpty) {
      await Future.delayed(Duration(seconds: 5));
    }
    return branchList;
  }
}
