import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OTPVerificationScreen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  void _sendOtp() async {
    String phone = '+964${_phoneController.text.trim()}';

    if (_phoneController.text.length != 10 || !_phoneController.text.startsWith('7')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رجاءً أدخل رقم عراقي صحيح')),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        // يمكن التحقق تلقائياً في بعض الأجهزة
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التحقق: ${e.message}')),
        );
        setState(() => isLoading = false);
      },
      codeSent: (verificationId, resendToken) {
        setState(() => isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(
              phoneNumber: phone,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              const Text(
                'أدخل رقم هاتفك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '+964 ',
                  border: OutlineInputBorder(),
                  labelText: 'رقم الهاتف',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال رمز التحقق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
