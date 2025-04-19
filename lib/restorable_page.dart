import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestorableProfileFormWidget extends StatefulWidget {
  const RestorableProfileFormWidget({Key? key}) : super(key: key);

  @override
  State<RestorableProfileFormWidget> createState() => _RestorableProfileFormWidgetState();
}

class _RestorableProfileFormWidgetState extends State<RestorableProfileFormWidget>
    with RestorationMixin {
  // تعريف الكنترولرز القابلة للاستعادة
  final RestorableTextEditingController _nameController = RestorableTextEditingController();
  final RestorableTextEditingController _emailController = RestorableTextEditingController();
  final RestorableTextEditingController _phoneController = RestorableTextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  String get restorationId => 'restorable_profile_form';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // تسجيل الكنترولرز للاستعادة
    registerForRestoration(_nameController, 'name_controller');
    registerForRestoration(_emailController, 'email_controller');
    registerForRestoration(_phoneController, 'phone_controller');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.value.text;
      final email = _emailController.value.text;
      final phone = _phoneController.value.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال البيانات:\n$name\n$email\n$phone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نموذج الملف الشخصي'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController.value,
                decoration: const InputDecoration(labelText: 'الاسم'),
                validator: (value) => value == null || value.isEmpty ? 'من فضلك أدخل الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController.value,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'أدخل بريدك الإلكتروني' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController.value,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'أدخل رقم هاتفك' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

