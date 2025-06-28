import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Démo SharedPreferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  // Clés pour SharedPreferences
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _rememberMeKey = 'remember_me';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Charger les identifiants sauvegardés
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString(_usernameKey) ?? '';
      _passwordController.text = prefs.getString(_passwordKey) ?? '';
      _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    });
  }

  // Sauvegarder les identifiants
  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString(_usernameKey, _usernameController.text);
      await prefs.setString(_passwordKey, _passwordController.text);
      await prefs.setBool(_rememberMeKey, _rememberMe);
    } else {
      // Si "Se souvenir de moi" n'est pas coché, on efface les données
      await prefs.remove(_usernameKey);
      await prefs.remove(_passwordKey);
      await prefs.setBool(_rememberMeKey, false);
    }
  }

  // Effacer toutes les données sauvegardées
  _clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _rememberMe = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Données effacées avec succès !'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Debug des SharedPreferences (pour les étudiants)
  _debugSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    
    String debugInfo = "=== SHARED PREFERENCES DEBUG ===\n";
    if (keys.isEmpty) {
      debugInfo += "Aucune donnée sauvegardée\n";
    } else {
      for (String key in keys) {
        Object? value = prefs.get(key);
        debugInfo += "$key = $value (${value.runtimeType})\n";
      }
    }
    debugInfo += "================================";
    
    print(debugInfo);
    
    // Afficher dans un dialog pour les étudiants
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debug SharedPreferences'),
        content: SingleChildScrollView(
          child: Text(
            keys.isEmpty 
              ? "Aucune donnée sauvegardée" 
              : keys.map((key) => "$key = ${prefs.get(key)}").join("\n"),
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  // Simuler une connexion
  _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulation d'une vérification
    await Future.delayed(Duration(seconds: 1));

    // Sauvegarder les identifiants si nécessaire
    await _saveCredentials();

    setState(() {
      _isLoading = false;
    });

    // Naviguer vers l'écran d'accueil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion - SharedPreferences'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Démo SharedPreferences',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            
            // Champ nom d'utilisateur
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nom d\'utilisateur',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            // Champ mot de passe
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            // Case à cocher "Se souvenir de moi"
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text('Se souvenir de moi'),
              ],
            ),
            SizedBox(height: 24),
            
            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Se connecter'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Bouton pour effacer les données
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _clearSavedData,
                child: Text('Effacer les données sauvegardées'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 8),
            
            // Bouton de debug (optionnel pour les étudiants)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _debugSharedPreferences,
                child: Text('🛠️ Debug SharedPreferences'),
              ),
            ),
            SizedBox(height: 24),
            
            // Informations sur l'état actuel
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'État actuel :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Username: ${_usernameController.text.isEmpty ? "Vide" : _usernameController.text}'),
                  Text('Password: ${_passwordController.text.isEmpty ? "Vide" : "●●●●●●"}'),
                  Text('Se souvenir: ${_rememberMe ? "Oui" : "Non"}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'Connexion réussie !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Bienvenue, $username !',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
