import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi/sindriver.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  void _verifyOtp() async {
    String smsCode = _otpController.text.trim();

    if (smsCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل الرمز المكون من 6 أرقام')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم التحقق بنجاح!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Sindriver()),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التحقق: $e')));
    }
  }

  void _resendOtp() async {
    // يمكنك إعادة إرسال OTP بنفس طريقة verifyPhoneNumber إذا أحببت
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إعادة الإرسال غير مفعلة مؤقتاً')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الرمز'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('أدخل الرمز المرسل إلى ${widget.phoneNumber}'),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'رمز OTP',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOtp,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('تحقق'),
            ),
            TextButton(
              onPressed: _resendOtp,
              child: const Text('إعادة إرسال الرمز'),
            ),
          ],
        ),
      ),
    );
  }
}
