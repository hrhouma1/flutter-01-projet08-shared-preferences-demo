#  Tutoriel : Localisation et lecture des SharedPreferences

Ce tutoriel explique où Flutter stocke les données SharedPreferences sur chaque plateforme et comment les consulter.

# Comprendre le stockage des SharedPreferences

Les SharedPreferences sont stockées différemment selon la plateforme :
- **Android** : Fichiers XML dans `/data/data/`
- **iOS** : Base de données SQLite dans `/Library/Preferences/`
- **Windows** : Registre Windows
- **Linux** : Fichiers dans `~/.local/share/`
- **macOS** : Fichiers `.plist`
- **Web** : LocalStorage du navigateur


<br/>
<br/>



# Android

### Emplacement
```
/data/data/com.example.demo_shared_preferences/shared_prefs/FlutterSharedPreferences.xml
```

### Comment accéder (avec un émulateur)

1. **Via Android Studio Device Explorer :**
   - Ouvrir Android Studio
   - Tools → Device Explorer
   - Naviguer vers : `data/data/com.example.demo_shared_preferences/shared_prefs/`
   - Double-cliquer sur `FlutterSharedPreferences.xml`

2. **Via ADB (Android Debug Bridge) :**
   ```bash
   # Se connecter au shell de l'émulateur
   adb shell
   
   # Naviguer vers le dossier
   cd /data/data/com.example.demo_shared_preferences/shared_prefs/
   
   # Lister les fichiers
   ls
   
   # Lire le contenu
   cat FlutterSharedPreferences.xml
   ```

3. **Extraire le fichier :**
   ```bash
   adb pull /data/data/com.example.demo_shared_preferences/shared_prefs/FlutterSharedPreferences.xml
   ```

### Format du fichier Android (XML)
```xml
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="flutter.username">admin</string>
    <string name="flutter.password">password123</string>
    <boolean name="flutter.remember_me" value="true" />
</map>
```

<br/>
<br/>

##  iOS

###  Emplacement
```
/Users/<username>/Library/Developer/CoreSimulator/Devices/<UUID>/data/Library/Preferences/<bundle-id>.plist
```

###  Comment accéder (avec un simulateur)

1. **Trouver l'UUID du simulateur :**
   ```bash
   xcrun simctl list devices
   ```

2. **Naviguer vers le dossier :**
   ```bash
   cd ~/Library/Developer/CoreSimulator/Devices/<UUID>/data/Library/Preferences/
   ls | grep demo_shared_preferences
   ```

3. **Lire le fichier .plist :**
   ```bash
   plutil -p com.example.demoSharedPreferences.plist
   ```

###  Format du fichier iOS (plist)
```xml
<dict>
    <key>flutter.username</key>
    <string>admin</string>
    <key>flutter.password</key>
    <string>password123</string>
    <key>flutter.remember_me</key>
    <true/>
</dict>
```

<br/>
<br/>

#  Windows

###  Emplacement
**Registre Windows :** `HKEY_CURRENT_USER\Software\<company>\<app_name>`

###  Comment accéder

1. **Via l'Éditeur de Registre (regedit) :**
   - Appuyer sur `Win + R` → taper `regedit`
   - Naviguer vers : `HKEY_CURRENT_USER\Software\`
   - Chercher le dossier de votre application

2. **Via PowerShell :**
   ```powershell
   # Lister les clés
   Get-ChildItem "HKCU:\Software\" | Where-Object {$_.Name -like "*demo*"}
   
   # Lire les valeurs
   Get-ItemProperty "HKCU:\Software\demo_shared_preferences"
   ```

3. **Via le terminal :**
   ```cmd
   reg query "HKEY_CURRENT_USER\Software\demo_shared_preferences"
   ```

###  Format Windows (Registre)
```
flutter.username    REG_SZ    admin
flutter.password    REG_SZ    password123
flutter.remember_me REG_DWORD 0x1
```

<br/>
<br/>

##  Linux

###  Emplacement
```
~/.local/share/demo_shared_preferences/shared_preferences.json
```

###  Comment accéder
```bash
# Naviguer vers le dossier
cd ~/.local/share/demo_shared_preferences/

# Lire le fichier JSON
cat shared_preferences.json

# Avec formatting
cat shared_preferences.json | python -m json.tool
```

###  Format Linux (JSON)
```json
{
  "flutter.username": "admin",
  "flutter.password": "password123",
  "flutter.remember_me": true
}
```

<br/>
<br/>

##  macOS

###  Emplacement
```
~/Library/Preferences/com.example.demo_shared_preferences.plist
```

###  Comment accéder
```bash
# Lire le fichier plist
plutil -p ~/Library/Preferences/com.example.demo_shared_preferences.plist

# Convertir en XML pour lecture
plutil -convert xml1 ~/Library/Preferences/com.example.demo_shared_preferences.plist -o -
```

<br/>
<br/>

##  Web (Navigateur)

###  Emplacement
**LocalStorage du navigateur**

###  Comment accéder

1. **Via les DevTools du navigateur :**
   - Ouvrir l'application dans Chrome/Firefox
   - Appuyer sur `F12` pour ouvrir les DevTools
   - Aller dans l'onglet **Application** (Chrome) ou **Storage** (Firefox)
   - Cliquer sur **Local Storage**
   - Sélectionner votre domaine (ex: `localhost:port`)

2. **Via la console JavaScript :**
   ```javascript
   // Lister toutes les clés
   for (let i = 0; i < localStorage.length; i++) {
       let key = localStorage.key(i);
       console.log(key + " = " + localStorage.getItem(key));
   }
   
   // Lire une clé spécifique
   localStorage.getItem('flutter.username')
   ```

###  Format Web (LocalStorage)
```
flutter.username = "admin"
flutter.password = "password123"
flutter.remember_me = "true"
```

---

## 🛠️ Outils de debugging dans le code

### Afficher toutes les clés sauvegardées
```dart
void debugSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();
  
  print("=== SHARED PREFERENCES DEBUG ===");
  for (String key in keys) {
    Object? value = prefs.get(key);
    print("$key = $value (${value.runtimeType})");
  }
  print("================================");
}
```

### Ajouter un bouton de debug dans votre app
```dart
ElevatedButton(
  onPressed: debugSharedPreferences,
  child: Text('Debug SharedPreferences'),
)
```

<br/>
<br/>

##  Conseils pour les tests

### 1. **Effacer les données pendant les tests**
```dart
// Dans vos tests
setUp(() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
});
```

### 2. **Utiliser des clés préfixées**
```dart
static const String _prefix = 'myapp_';
static const String _usernameKey = '${_prefix}username';
```

### 3. **Vérifier l'existence des données**
```dart
bool hasData = prefs.containsKey('username');
```

<br/>
<br/>

##  Notes importantes

### **Sécurité :**
-  Les SharedPreferences ne sont **PAS chiffrées** par défaut
-  Ne jamais stocker de données sensibles (mots de passe, tokens)
- Utiliser `flutter_secure_storage` pour les données sensibles

### **Limitations :**
- Android : Effacées lors de la désinstallation
- iOS : Sauvegardées dans iCloud par défaut
- Web : Limitées par les quotas du navigateur
- Windows : Persistantes même après désinstallation

<br/>
<br/>

# Commandes utiles pour le développement

```bash
# Effacer le cache de l'app (Android)
adb shell pm clear com.example.demo_shared_preferences

# Réinstaller l'app
flutter clean && flutter run

# Voir les logs en temps réel
flutter logs
```


**🎓 Ce tutoriel vous permet de comprendre exactement où et comment Flutter stocke vos SharedPreferences sur chaque plateforme !** 
