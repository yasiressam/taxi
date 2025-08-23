import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class Sindriver extends StatefulWidget {
  const Sindriver({super.key});

  @override
  State<Sindriver> createState() => _SindriverState();
}

class _SindriverState extends State<Sindriver>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carController = TextEditingController();
  final TextEditingController wasController = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> sendOTP() async {
    if (phoneController.text.isEmpty ||
        nameController.text.isEmpty ||
        carController.text.isEmpty ||
        wasController.text.isEmpty ||
        selectedImage == null) {
      Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول واختيار صورة");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar("نجاح", "تم إرسال رمز التحقق إلى الهاتف");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال OTP: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    phoneController.dispose();
    carController.dispose();
    wasController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFD4B483)), // أيقونة كريمي
      labelStyle: GoogleFonts.cairo(color: Colors.brown[800]),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4B483)), // حدود كريمي
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBFA176), width: 2),
      ),
      fillColor: Colors.white.withOpacity(0.95),
      filled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)], // اللون الأصلي
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SlideTransition(
            position: _animation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "قم بانشاء حسابك كسائق للانضمام معنا واستلام الطلبات",
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          style: GoogleFonts.cairo(),
                          decoration: _inputDecoration(
                            "الاسم الكامل",
                            Icons.person,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(),
                          decoration: _inputDecoration(
                            "رقم الهاتف",
                            Icons.phone,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: wasController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(),
                          decoration: _inputDecoration(
                            "واتساب للتواصل",
                            Icons.phone_bluetooth_speaker,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: carController,
                          style: GoogleFonts.cairo(),
                          decoration: _inputDecoration(
                            "نوع وموديل السيارة",
                            Icons.car_crash,
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.image,
                                  color: Color(0xFFD4B483),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  selectedImage == null
                                      ? "اختر صورة"
                                      : "تم اختيار صورة",
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    color: Colors.brown[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: sendOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFFD4B483,
                                  ), // كريمي
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 40,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  "إرسال رمز التحقق",
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    color: Colors.brown[900],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
