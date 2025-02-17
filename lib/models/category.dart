import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;
  int entries;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    this.entries = 0,
  });
}