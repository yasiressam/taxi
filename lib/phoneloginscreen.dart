import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taxi/OTPVerificationScreen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _digits = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _digits.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final raw = _digits.text.trim();
    if (raw.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(raw) ||
        !raw.startsWith('7')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رجاءً أدخل رقم عراقي صحيح (10 أرقام ويبدأ بـ 7)'),
        ),
      );
      return;
    }

    final phone = '+964$raw';
    setState(() => isLoading = true);

    // محاكاة إرسال OTP
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isLoading = false);

    // الانتقال لصفحة OTPVerificationScreen مع تمرير المعلومات
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OTPVerificationScreen(
          phoneNumber: phone,
          verificationId: "dummy_verification_id", // رمز وهمي
          otp: "123456", // OTP وهمي للمحاكاة
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال رمز التحقق (محاكاة)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kGold = const Color(0xFFF3C26B);
    final pinTheme = PinTheme(
      width: 34,
      height: 48,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(child: Image.asset('assets/images/taxi.jpg', height: 120)),
              const SizedBox(height: 28),
              const Text(
                'أدخل رقم هاتفك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Text(
                      '+964',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: _digits,
                        length: 10,
                        keyboardType: TextInputType.number,
                        defaultPinTheme: pinTheme,
                        focusedPinTheme: pinTheme.copyWith(
                          decoration: pinTheme.decoration!.copyWith(
                            border: Border.all(color: kGold, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('إرسال رمز التحقق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
