
import 'package:flutter/material.dart';

class RestorableStringDatePage extends StatefulWidget {
  const RestorableStringDatePage({super.key});

  @override
  State<RestorableStringDatePage> createState() => _RestorableStringDatePageState();
}

class _RestorableStringDatePageState extends State<RestorableStringDatePage> with RestorationMixin {
  final RestorableString _text = RestorableString('Hello');
  final RestorableDateTime _date = RestorableDateTime(DateTime.now());

  @override
  String get restorationId => 'string_date_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_text, 'text');
    registerForRestoration(_date, 'date');
  }

  @override
  void dispose() {
    _text.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) setState(() => _date.value = newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('String & DateTime')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Message: ${_text.value}'),
            TextField(
              onChanged: (val) => _text.value = val,
              decoration: const InputDecoration(labelText: 'Enter message'),
            ),
            const SizedBox(height: 20),
            Text('Date: ${_date.value.toLocal()}'.split(' ')[0]),
            ElevatedButton(onPressed: _pickDate, child: const Text('Pick Date')),
          ],
        ),
      ),
    );
  }
}
