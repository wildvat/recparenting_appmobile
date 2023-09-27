import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/api_response.dart';

class ShowApiErrorWidget{
  final BuildContext context;
  final ApiResponse apiResponse;

  ShowApiErrorWidget({required this.context, required this.apiResponse});


  execute(){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(apiResponse.error.toString()),
          showCloseIcon: true,
        ));
  }
}