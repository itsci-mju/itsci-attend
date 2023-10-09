import 'package:flutter/material.dart';

// ความกว้างของแท็บบาร์และภายในแท็บ
final double appBarWidth = kToolbarHeight;

var kMyAppBar = AppBar(
  title: Image.asset(
    'images/mju_logo_main-resize.png',
    height: appBarWidth, // ตั้งความสูงของรูปเท่ากับความสูงของแท็บบาร์
  ),
  toolbarHeight: appBarWidth,
  backgroundColor: Colors.white,
  elevation: 10,
);
