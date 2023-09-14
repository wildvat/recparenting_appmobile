/*
import 'package:flutter/material.dart';

class MyCustomScaffold extends Scaffold {
  static GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();
  MyCustomScaffold({
    super.appBar,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.drawer,
    super.endDrawer,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    bool resizeToAvoidBottomPadding = true,
    bool primary = true,
  }) : super(
          key: _keyScaffold,
          appBar: endDrawer != null &&
                  appBar.actions != null &&
                  appBar.actions.isNotEmpty
              ? _buildEndDrawerButton(appBar)
              : appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
          primary: primary,
        );

  static AppBar _buildEndDrawerButton(AppBar myAppBar) {
    myAppBar.actions.add(IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => !_keyScaffold.currentState.isEndDrawerOpen
            ? _keyScaffold.currentState.openEndDrawer()
            : null));
    return myAppBar;
  }
}
*/