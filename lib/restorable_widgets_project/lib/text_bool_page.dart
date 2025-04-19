
import 'package:flutter/material.dart';

class RestorableTextBoolPage extends StatefulWidget {
  const RestorableTextBoolPage({super.key});

  @override
  State<RestorableTextBoolPage> createState() => _RestorableTextBoolPageState();
}

class _RestorableTextBoolPageState extends State<RestorableTextBoolPage> with RestorationMixin {
  final RestorableTextEditingController _controller = RestorableTextEditingController();
  final RestorableBool _isChecked = RestorableBool(false);

  @override
  String get restorationId => 'text_bool_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_controller, 'text_field');
    registerForRestoration(_isChecked, 'checkbox_value');
  }

  @override
  void dispose() {
    _controller.dispose();
    _isChecked.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text & Checkbox')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller.value),
            CheckboxListTile(
              title: const Text('Accept Terms'),
              value: _isChecked.value,
              onChanged: (val) {
                setState(() => _isChecked.value = val ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
