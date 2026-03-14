import 'package:flutter/material.dart';

void main() {
  runApp(const DigiPinApp());
}

class DigiPinApp extends StatelessWidget {
  const DigiPinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiPIN App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DigiPIN App")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Saved Locations"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Stored Locations"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.location_searching),
              label: const Text("Get My DigiPIN"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GetMyDigiPinPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Search with DigiPIN"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchDigiPinPage()),
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text("🚨 SOS (Disabled)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("SOS feature disabled.")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GetMyDigiPinPage extends StatefulWidget {
  const GetMyDigiPinPage({super.key});

  @override
  State<GetMyDigiPinPage> createState() => _GetMyDigiPinPageState();
}

class _GetMyDigiPinPageState extends State<GetMyDigiPinPage> {
  String _digiPin = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchDigiPin();
  }

  Future<void> _fetchDigiPin() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _digiPin = "629163"; // Mock DigiPIN
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My DigiPIN")),
      body: Center(
        child: _digiPin == "Fetching..."
            ? const CircularProgressIndicator()
            : Text(
                "Your DigiPIN: $_digiPin",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class SearchDigiPinPage extends StatefulWidget {
  const SearchDigiPinPage({super.key});

  @override
  State<SearchDigiPinPage> createState() => _SearchDigiPinPageState();
}

class _SearchDigiPinPageState extends State<SearchDigiPinPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  bool _isLoading = false;

  void _searchDigiPin() async {
    final String pin = _controller.text.trim();

    if (pin.length != 6 || int.tryParse(pin) == null) {
      setState(() {
        _result = "Please enter a valid 6-digit number.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "";
    });

    await Future.delayed(const Duration(seconds: 1));

    Map<String, String> mockData = {
      "629163": "Manavalakurichi, Tamil Nadu",
      "600001": "Chennai, Tamil Nadu",
      "110001": "New Delhi",
      "400001": "Mumbai, Maharashtra",
    };

    setState(() {
      _result = mockData[pin] ?? "No area found for this DigiPIN.";
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search with DigiPIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter DigiPIN (6 digits)"),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchDigiPin,
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _result,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}