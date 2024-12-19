import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Application System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// Common Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blueAccent,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Text(text),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application Hub'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Create Profile',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'View Available Jobs',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JobListScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Create Profile Screen
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _phoneNumber = '';

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetailsScreen(
            username: _username,
            email: _email,
            phoneNumber: _phoneNumber,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Username',
                onChanged: (value) => _username = value,
                validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Email',
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an email';
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Phone Number',
                onChanged: (value) => _phoneNumber = value,
                validator: (value) =>
                    value!.length != 10 ? 'Phone number must be 10 digits' : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              CustomButton(text: 'Proceed', onPressed: _submitForm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}

// Profile Details Screen
class ProfileDetailsScreen extends StatelessWidget {
  final String username;
  final String email;
  final String phoneNumber;

  const ProfileDetailsScreen({
    required this.username,
    required this.email,
    required this.phoneNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildProfileRow('👤 Username', username),
            _buildProfileRow('📧 Email', email),
            _buildProfileRow('📞 Phone Number', phoneNumber),
            const SizedBox(height: 30),
            Center(
              child: CustomButton(
                text: 'Back',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text('$title: $value', style: const TextStyle(fontSize: 18)),
    );
  }
}

// Job List Screen
class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  final List<Map<String, String>> jobs = const [
    {'title': 'Software Engineer', 'company': 'TechCorp'},
    {'title': 'Data Analyst', 'company': 'DataWorld'},
    {'title': 'Product Manager', 'company': 'InnoVentures'},
    {'title': 'UI/UX Designer', 'company': 'DesignStudio'},
    {'title': 'Flutter Developer', 'company': 'AppWorks'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.work, color: Colors.blueAccent),
              title: Text(jobs[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Company: ${jobs[index]['company']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Applied for ${jobs[index]['title']} at ${jobs[index]['company']}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Apply'),
              ),
            ),
          );
        },
      ),
    );
  }
}
