# Marché de Yama — Backoffice (application bureau)

Application Windows (Flutter) qui affiche le backoffice de Marché de Yama, <https://backoffice.marche2yama.com>, dans une fenêtre dédiée : la page web occupe toute la fenêtre, sans barre d'application.

## Fonctionnement

- Fenêtre maximisée au démarrage (minimum 1024 × 700).
- Page web rendue par **WebView2** (Microsoft Edge) via `webview_windows`, fenêtre gérée par `window_manager`.
- Barre de progression pendant le chargement ; écran d'erreur avec bouton « Réessayer » si le réseau est coupé.
- Les liens qui s'ouvriraient dans une nouvelle fenêtre restent dans celle-ci.

## Prérequis

- Windows 10 ou 11 avec le *Microsoft Edge WebView2 Runtime* (déjà présent sur Windows 11).
- Pour développer : Flutter (stable), Visual Studio Build Tools 2022 (charge de travail « Développement Desktop en C++ ») et [NuGet](https://www.nuget.org/downloads) dans le `PATH` (requis par `webview_windows`).

## Développement

```powershell
flutter pub get
flutter run -d windows
```

L'adresse chargée est la constante `backofficeUrl` de [`lib/main.dart`](lib/main.dart).

## Générer l'installateur

```powershell
flutter build windows --release
& "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" installer\setup.iss
```

L'installateur est produit dans `installer\output\Setup_Backoffice_Marche_de_Yama.exe` (Inno Setup 6, interface en français, raccourcis Menu Démarrer et Bureau).
