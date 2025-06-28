# Démo SharedPreferences Flutter

Une application de démonstration pour enseigner l'utilisation des SharedPreferences en Flutter.

## 📱 Fonctionnalités

Cette application démontre :

-  **Interface d'authentification** avec champs username/password
-  **Case "Se souvenir de moi"** pour sauvegarder les identifiants
-  **Chargement automatique** des identifiants sauvegardés au démarrage
-  **Bouton d'effacement** pour supprimer toutes les données sauvegardées
-  **Affichage en temps réel** de l'état des données
-  **Navigation** vers un écran d'accueil après connexion

# Installation et lancement

1. **Cloner ou télécharger le projet**
2. **Installer les dépendances :**
   ```bash
   flutter pub get
   ```
3. **Lancer l'application :**
   ```bash
   flutter run
   ```

# Utilisation pour apprendre

### Test des fonctionnalités :

1. **Saisir des identifiants** (exemple : admin/password)
2. **Cocher "Se souvenir de moi"** et se connecter
3. **Redémarrer l'application** → Les champs sont pré-remplis !
4. **Décocher "Se souvenir de moi"** et se reconnecter → Les données sont effacées
5. **Utiliser le bouton "Effacer"** pour supprimer toutes les données

### Points d'apprentissage :

- **Persistance des données** entre les sessions
- **Gestion des préférences utilisateur**
- **Sauvegarde/chargement asynchrone**
- **Suppression des données**

# Concepts techniques abordés

### SharedPreferences - Méthodes utilisées :

```dart
// Obtenir une instance
SharedPreferences prefs = await SharedPreferences.getInstance();

// Sauvegarder des données
await prefs.setString('username', 'admin');
await prefs.setBool('remember_me', true);

// Charger des données
String? username = prefs.getString('username');
bool rememberMe = prefs.getBool('remember_me') ?? false;

// Supprimer des données
await prefs.remove('username');
await prefs.clear(); // Supprime tout
```

### Architecture du code :

- **État local** avec `StatefulWidget`
- **Contrôleurs de texte** pour les champs
- **Méthodes asynchrones** pour SharedPreferences
- **Navigation** entre écrans
- **Gestion des erreurs** et messages utilisateur

# Exercices suggérés pour les étudiants

1. **Ajouter un thème sombre** sauvegardé dans SharedPreferences
2. **Implémenter une langue** (français/anglais) mémorisée
3. **Ajouter une liste de favoris** persistante
4. **Créer un système de paramètres** complet
5. **Ajouter une validation** avancée des champs

# Extensions possibles

- Chiffrement des mots de passe
- Gestion de plusieurs utilisateurs
- Sauvegarde dans un fichier JSON
- Integration avec une base de données locale (SQLite)

# Documentation officielle

- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)



**Bonne démonstration !**
