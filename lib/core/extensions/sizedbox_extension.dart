import 'package:flutter/material.dart';

extension SizedBoxExtension on SizedBox {
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}
