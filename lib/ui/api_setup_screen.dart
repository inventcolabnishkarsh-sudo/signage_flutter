import 'package:flutter/material.dart';
import '../services/signage_config_service.dart';
import 'app_loader.dart';

class ApiSetupScreen extends StatefulWidget {
  ApiSetupScreen({super.key});

  @override
  State<ApiSetupScreen> createState() => _ApiSetupScreenState();
}

class _ApiSetupScreenState extends State<ApiSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    final url = _controller.text.trim();

    if (url.isEmpty || !url.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid API base URL')),
      );
      return;
    }

    setState(() => _saving = true);

    await SignageConfigService.saveBaseUrl(url);

    // Restart flow → AppLoader will now go to AppBootstrap
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AppLoader()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Configuration'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Backend API Base URL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Example:\nhttps://server-ip/api/',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'https://server-ip/api/',
                labelText: 'API Base URL',
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
