import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;
import 'LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> insertrecord() async {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        birthdayController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      if (passwordController.text.length >= 8 &&
          passwordController.text.contains(RegExp(r'[A-Z]'))) {
        String uri = "${constant.cim}insert_record.php";
        var res = await http.post(Uri.parse(uri), body: {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "birthday": birthdayController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
        });

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          _showSuccessSnackbar();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          print("some issue");
        }
      } else {
        _showPasswordRequirementsSnackbar();
      }
    } else {
      _showIncompleteFieldsSnackbar();
    }
  }

  void _showIncompleteFieldsSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tölts ki mindent')),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('A Regisztráció sikeres volt')),
    );
  }

  void _showPasswordRequirementsSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          'A jelszónak legalább 8 karakterből kell állnia és legalább egy nagy betűt tartalmaznia kell')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 20),
                  Text(
                    'Create account',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(firstNameController, 'First Name'),
                  _buildTextField(lastNameController, 'Last Name'),
                  _buildTextField(birthdayController, 'Birthday',
                      readOnly: true, onTap: () => _selectDate(context)),
                  _buildTextField(phoneController, 'Phone'),
                  _buildTextField(emailController, 'Email'),
                  _buildTextField(passwordController, 'Password', obscureText: true),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: insertrecord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(300, 50),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Or',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.orange,
                      fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false, bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: hintText == 'Birthday'
              ? Icon(Icons.calendar_today)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        birthdayController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }
}
