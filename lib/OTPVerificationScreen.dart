import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final String otp;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.otp,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  void _verifyOTP() async {
    String otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("الرجاء إدخال رمز صحيح")));
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // محاكاة التحقق

    if (!mounted) return;
    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("تم التحقق بنجاح برمز: $otp")));
  }

  void _resendOTP() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // محاكاة إعادة الإرسال

    if (!mounted) return;
    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إرسال رمز جديد")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التحقق من الرمز"),
        centerTitle: true,
        backgroundColor: const Color(0xFFD4B483), // كريمي
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "أدخل الرمز المرسل إلى: ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: "رمز OTP",
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4B483),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "تحقق",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.brown[900],
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: isLoading ? null : _resendOTP,
              child: Text(
                "إعادة إرسال الرمز",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
