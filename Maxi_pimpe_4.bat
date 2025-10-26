@echo off
setlocal enabledelayedexpansion

:: ======================================================================
:: Configuration initiale
:: ======================================================================
title Maxi Pimp v4.4 - Interface centree
:: Couleur: Fond Noir (0), Texte Jaune Clair (e)
color 0e

:: ======================================================================
:: Vérification des droits administrateur
:: ======================================================================
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo  [ERREUR] Ce script necessite des privileges administrateur.
    echo.
    echo  Tentative de relance automatique...
    echo  Veuillez accepter l'invite UAC.
    echo.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ======================================================================
:: Menu Principal (Boucle)
:: ======================================================================
:mainMenu
cls

:: Lapin ASCII supprimé pour une interface propre

echo.
echo ======================================================================
echo                  UTILITAIRE MAXI PIMP
echo ======================================================================
echo.
echo   Connecte en tant que: %USERNAME% (Admin)
echo.
echo   --- NETTOYAGE ^& OPTIMISATION ---
echo.
echo     [1] Nettoyage complet des fichiers temporaires
echo     [2] Ouvrir le Nettoyage de Disque Windows (cleanmgr)
echo     [3] Vider le cache DNS
echo     [4] Optimiser les disques (Deframentation)
echo.
echo   --- DIAGNOSTIC ^& INFORMATIONS ---
echo.
echo     [5] Verifier l'integrite des fichiers systeme (SFC)
echo     [6] Afficher les informations systeme
echo     [7] Afficher les connexions reseau actives (netstat)
echo     [8] Gerer les comptes utilisateurs
echo.
echo   --- OUTILS RESEAU ---
echo.
echo     [A] Afficher la configuration IP (Detaillee)
echo     [B] Tester la connexion Internet (Ping Google)
echo     [F] Outils Wi-Fi
echo.
echo   --- GESTION DE L'ALIMENTATION ---
echo.
echo     [C] Planifier un arret (90 minutes)
echo     [D] Annuler l'arret planifie
echo     [E] Redemarrer l'ordinateur
echo.
echo   ------------------------------------------------------------------
echo     [0] Quitter
echo.

:: Navigation par 'choice' - Ajout de 'F'
choice /C 12345678ABCDEF0 /N /M "MaxiPimp: "

if errorlevel 15 goto :opt_0
if errorlevel 14 goto :opt_F
if errorlevel 13 goto :opt_E
if errorlevel 12 goto :opt_D
if errorlevel 11 goto :opt_C
if errorlevel 10 goto :opt_B
if errorlevel 9 goto :opt_A
if errorlevel 8 goto :opt_8
if errorlevel 7 goto :opt_7
if errorlevel 6 goto :opt_6
if errorlevel 5 goto :opt_5
if errorlevel 4 goto :opt_4
if errorlevel 3 goto :opt_3
if errorlevel 2 goto :opt_2
if errorlevel 1 goto :opt_1 

goto mainMenu

:: ======================================================================
:: SOUS-MENU Wi-Fi
:: ======================================================================
:menuWifi
call :drawHeader "Menu Outils Wi-Fi"
echo   [1] Afficher les mots de passe Wi-Fi enregistres
echo   [2] Lister les reseaux Wi-Fi a proximite
echo   [3] Afficher les details de la connexion Wi-Fi actuelle
echo   [4] Generer un rapport de diagnostic Wi-Fi
echo.
echo   [0] Retour au menu principal
echo.

choice /C 12340 /N /M "Menu Wi-Fi: "

if errorlevel 5 goto :mainMenu
if errorlevel 4 goto :opt_wifi_4
if errorlevel 3 goto :opt_wifi_3
if errorlevel 2 goto :opt_wifi_2
if errorlevel 1 goto :opt_wifi_1

goto :menuWifi

:: ======================================================================
:: DEFINITION DES ACTIONS (Wi-Fi)
:: ======================================================================

:opt_F
goto :menuWifi

:opt_wifi_1
call :drawHeader "Mots de passe Wi-Fi enregistres"
echo Recherche des profils Wi-Fi enregistres...
echo.
:: Boucle sur tous les profils, extrait le nom, puis cherche la clé
for /f "tokens=4,* delims=:" %%a in ('netsh wlan show profiles ^| find "Profil tous utilisateurs"') do (
    set "profileName=%%a"
    set "profileName=!profileName:~1!"
    echo ------------------------------------------
    echo  Profil: !profileName!
    echo ------------------------------------------
    
    :: Crée un fichier temporaire pour analyse
    netsh wlan show profile name="!profileName!" key=clear > "%temp%\wifi_key.txt"
    
    :: Cherche la ligne "Contenu de la cle"
    findstr /C:"Contenu de la cle" "%temp%\wifi_key.txt" >nul
    
    if !errorlevel! == 0 (
        :: Si trouvé, l'affiche
        for /f "tokens=2,* delims=:" %%k in ('findstr /C:"Contenu de la cle" "%temp%\wifi_key.txt"') do (
            echo  Mot de passe: %%k
        )
    ) else (
        echo  Mot de passe: [Reseau d'entreprise ou sans cle]
    )
    echo.
)
del "%temp%\wifi_key.txt" >nul 2>&1
call :pauseAndReturnWifi

:opt_wifi_2
call :drawHeader "Reseaux Wi-Fi a proximite"
netsh wlan show networks
call :pauseAndReturnWifi

:opt_wifi_3
call :drawHeader "Details de la connexion Wi-Fi actuelle"
netsh wlan show interfaces
call :pauseAndReturnWifi

:opt_wifi_4
call :drawHeader "Rapport de diagnostic Wi-Fi"
echo Generation du rapport en cours...
netsh wlan show wlanreport
echo.
echo Rapport genere. Il se trouve ici:
echo C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html
echo.
echo Voulez-vous l'ouvrir maintenant?
choice /C ON /M "(O)ui / (N)on: "
if errorlevel 2 goto :pauseAndReturnWifi
if errorlevel 1 start "" "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html"
call :pauseAndReturnWifi


:: ======================================================================
:: DEFINITION DES ACTIONS (Principales)
:: ======================================================================

:opt_1
call :drawHeader "Nettoyage complet des fichiers temporaires"
echo Nettoyage de C:\Windows\Temp...
del /f /s /q C:\Windows\Temp\*.* >nul
echo.
echo Nettoyage de %TEMP% (fichiers temporaires utilisateur)...
del /f /s /q "%TEMP%\*.*" >nul
echo.
echo Nettoyage termine.
echo (Certains fichiers ont pu etre ignores s'ils sont en cours d'utilisation)
call :pauseAndReturn

:opt_2
call :drawHeader "Nettoyage de Disque Windows"
echo Lancement de l'utilitaire de Nettoyage de Disque (cleanmgr.exe)...
start "Nettoyage" cleanmgr.exe
echo L'utilitaire est lance dans une nouvelle fenetre.
call :pauseAndReturn

:opt_3
call :drawHeader "Vider le cache DNS"
ipconfig /flushdns
echo.
echo Cache de resolution DNS vide.
call :pauseAndReturn

:opt_4
call :drawHeader "Optimiser les disques (Deframentation)"
echo Lancement de l'optimisation de tous les lecteurs...
defrag /C /O /V
echo.
echo Optimisation terminee.
call :pauseAndReturn

:opt_5
call :drawHeader "Verification des fichiers systeme (SFC)"
echo Lancement de 'sfc /scannow'.
echo Cette operation peut prendre plusieurs minutes.
sfc /scannow
echo.
echo Verification terminee. Consultez le journal pour les details.
call :pauseAndReturn

:opt_6
call :drawHeader "Informations systeme"
systeminfo
echo.
call :pauseAndReturn

:opt_7
call :drawHeader "Connexions reseau actives (netstat -an)"
echo Affichage des connexions et ports d'ecoute...
netstat -an
echo.
call :pauseAndReturn

:opt_8
call :drawHeader "Gestion des comptes utilisateurs"
echo Liste des comptes utilisateurs locaux:
echo -----------------------------------
net user
echo -----------------------------------
echo.
echo Ouverture du panneau de gestion des comptes...
start "Comptes" control userpasswords2
echo Panneau de gestion lance.
call :pauseAndReturn

:opt_A
call :drawHeader "Configuration IP (Detaillee)"
ipconfig /all
echo.
call :pauseAndReturn

:opt_B
call :drawHeader "Test de connexion Internet (Ping Google)"
echo Ping en continu vers 8.8.8.8 (DNS Google).
echo Appuyez sur Ctrl+C pour arreter le test.
echo.
ping 8.8.8.8 -t
call :pauseAndReturn

:opt_C
call :drawHeader "Planifier un arret (90 minutes)"
:: 5400 secondes = 90 minutes
shutdown -s -t 5400
echo L'arret du systeme est planifie dans 90 minutes.
echo (Choisissez [D] au menu principal pour annuler)
call :pauseAndReturn

:opt_D
call :drawHeader "Annuler l'arret planifie"
shutdown -a
echo Arret planifie annule avec succes.
call :pauseAndReturn

:opt_E
call :drawHeader "Redemarrer l'ordinateur"
echo.
echo Voulez-vous VRAIMENT redemarrer maintenant?
choice /C ON /M "(O)ui / (N)on: "
if errorlevel 2 goto :mainMenu
if errorlevel 1 (
    echo Redemarrage en cours...
    shutdown /r /t 0
)
goto :mainMenu

:opt_0
cls
echo Merci d'avoir utilise Maxi Pimp. Au revoir!
timeout /t 2 >nul
exit /b

:: ======================================================================
:: SOUS-ROUTINES (FONCTIONS)
:: ======================================================================

:drawHeader
:: Affiche un en-tête propre pour chaque section
:: %~1 récupère le premier argument (le titre)
cls
echo ======================================================================
echo   %~1
echo ======================================================================
echo.
goto :EOF

:pauseAndReturn
:: Affiche un message de pause et retourne au menu principal
echo.
echo Appuyez sur n'importe quelle touche pour retourner au menu...
pause >nul
goto mainMenu

:pauseAndReturnWifi
:: Affiche un message de pause et retourne au menu Wi-Fi
echo.
echo Appuyez sur n'importe quelle touche pour retourner au menu Wi-Fi...
pause >nul
goto :menuWifi