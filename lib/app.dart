// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:Shrine/backdrop.dart';
import 'package:Shrine/category_menu_page.dart';
import 'package:Shrine/colors.dart';
import 'package:Shrine/model/product.dart';
import 'package:Shrine/supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'login.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatefulWidget {
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  Category _currentCategory = Category.all;
  ScrollController _scrollController;
  bool _showElevation = false;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showElevation = false;
      });
    }

    if (_scrollController.offset > 10) {
      setState(() {
        _showElevation = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
    ));

    return MaterialApp(
      title: 'Shrine',
      // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
      home: BackDrop(
        // Todo make currentCategory field take _currentCategory (104)
        currentCategory: Category.all,
        // Todo pass _currentCategory for frontLayer (104)
        frontLayer: HomePage(
          category: _currentCategory,
        ),
        // Todo: change backLayer field value to CategoryMenuPage (104)
        backLayer: CategoryMenuPage(
          currentCategory: _currentCategory,
          onCategoryTap: _onCategoryTap,
        ),
        frontTitle: Text("SHRINE"),
        backTitle: Text("MENU"),
      ),
      // TODO: Make currentCategory field take _currentCategory (104)
      // TODO: Pass _currentCategory for frontLayer (104)
      // TODO: Change backLayer field value to CategoryMenuPage (104)
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      // TODO: Add a theme (103)
      theme: _buildShrineTheme(context),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

// TODO: Build a Shrine Theme (103)
// final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme(BuildContext context) {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    accentColor: accentColor,
    primaryColor: primaryColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: Theme.of(context).appBarTheme.copyWith(
          textTheme: Theme.of(context).textTheme,
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: darkIconColor,
              ),
        ),
    cardColor: primaryColor,
    textSelectionColor: accentColor,
    errorColor: errorColor,
    iconTheme: Theme.of(context).iconTheme.copyWith(
          color: darkIconColor,
        ),
    // Todo: add the text themes (103)
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    // todo add the icon themes (103)
    primaryIconTheme: base.iconTheme.copyWith(
      color: darkIconColor,
    ),
    hintColor: accentColor,
    // TODO decorate the inputs (103)
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      hasFloatingPlaceholder: false,
      fillColor: fillColor,
      labelStyle: TextStyle(
        color: darkTextColor,
      ),
      hintStyle: TextStyle(
        color: darkTextColor,
      ),
      border: CutCornersBorder(),
      enabledBorder: CutCornersBorder(
        borderSide: BorderSide(
          color: accentColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(
          color: accentColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
    ),
  );
}

// TODO: Build a Shrine Text Theme (103)
TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(fontWeight: FontWeight.w500),
        title: base.title.copyWith(
          fontSize: 18.0,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: "Rubik",
        displayColor: darkTextColor,
        bodyColor: darkTextColor,
      );
}
