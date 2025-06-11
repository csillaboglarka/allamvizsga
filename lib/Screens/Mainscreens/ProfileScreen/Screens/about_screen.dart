import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String termsAndConditions = '''
By using this app, you agree to responsible use. 
The data of the app's users is encrypted. 
  ''';

  final String contactEmail = 'info@app.com';
  final String contactnumber = '0700000000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Terms of use',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                termsAndConditions,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Contact',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Email: $contactEmail',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Phone: $contactnumber',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
