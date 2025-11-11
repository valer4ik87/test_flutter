import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GifDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/details'),
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}