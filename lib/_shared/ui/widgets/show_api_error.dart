import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';

import '../../models/api_response.dart';

class ShowApiErrorWidget {
  final BuildContext context;
  final ApiResponse apiResponse;

  ShowApiErrorWidget({required this.context, required this.apiResponse}) {
    SnackBarRec(message: apiResponse.error.toString());
  }
}
