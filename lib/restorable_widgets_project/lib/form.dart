
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> with RestorationMixin {
  final RestorableTextEditingController _controller =
  RestorableTextEditingController();

  @override
  String get restorationId => 'my_form_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_controller, 'text_field');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النموذج')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller.value,
              decoration: const InputDecoration(
                labelText: 'أدخل النص هنا',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              child: const Text('رجوع'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}