import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

enum Availability { loading, available, unavailable }

class ReviewApp extends StatefulWidget {
  const ReviewApp({super.key});

  @override
  State<ReviewApp> createState() => _ReviewAppState();
}

class _ReviewAppState extends State<ReviewApp> {
  final InAppReview _inAppReview = InAppReview.instance;

  String _appStoreId = '';
  Availability _availability = Availability.loading;

  @override
  void initState() {
    super.initState();
    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();

        setState(() {
          // This plugin cannot be tested on Android by installing your app
          // locally. See https://github.com/britannio/in_app_review#testing for
          // more information.
          _availability = isAvailable && !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;
        });
      } catch (_) {
        setState(() => _availability = Availability.unavailable);
      }
    });
  }

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: _appStoreId,
      );

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
