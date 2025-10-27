Maxi Pimp - Utilitaire de Maintenance Windows

<img width="1308" height="632" alt="image" src="https://github.com/user-attachments/assets/45925af7-379c-462f-902a-e48e72d983a5" />

Le Projet: "Maxi Pimp" est un de mes tout premiers projets, écrit en script Batch (.bat) lorsque j'étais adolescent. C'était ma première tentative de créer un "couteau suisse" pour la maintenance et le diagnostic de Windows. Aujourd'hui étudiant en M2 de Psychologie Ergonomie, spécialisé en UI/UX, je garde ce projet comme un souvenir amusant de mes débuts et de ma passion pour l'informatique. Le code a été récemment nettoyé, sécurisé et amélioré pour être plus fonctionnel et stable, tout en gardant son âme d'origine.

Fonctionnalités: L'utilitaire propose plusieurs outils accessibles via un menu interactif :

Nettoyage & Optimisation : Nettoyage des fichiers temporaires (%TEMP%, C:\Windows\Temp), Lancement du Nettoyage de Disque Windows, Optimisation des disques (Défragmentation), Vidage du cache DNS.

Diagnostic & Informations : Vérification de l'intégrité des fichiers système (sfc /scannow), Affichage des informations système (systeminfo), Affichage des connexions réseau actives (netstat -an), Gestion des comptes utilisateurs.

Outils Réseau & Wi-Fi : Affichage de la configuration IP détaillée (ipconfig /all), Test de la connexion Internet (Ping Google), et un sous-menu Wi-Fi pour afficher les mots de passe des réseaux Wi-Fi enregistrés, lister les réseaux à proximité, et générer un rapport de diagnostic Wi-Fi.

Gestion de l'alimentation : Planifier un arrêt (dans 90 minutes), Annuler l'arrêt planifié, Redémarrer l'ordinateur.

Utilisation: Ce script nécessite des privilèges élevés pour exécuter la plupart de ses commandes (SFC, nettoyage, commandes réseau, etc.).

Téléchargez le fichier .bat.

Faites un clic droit sur le fichier.

Sélectionnez "Exécuter en tant qu'administrateur".

Problème d'accents ? L'invite de commande Windows peut mal afficher les accents si le fichier n'a pas le bon encodage. Solution : Ouvrez le fichier .bat dans un éditeur de texte (comme le Bloc-notes ou Notepad++) et ré-enregistrez-le en choisissant l'encodage ANSI.

Disclaimer: Ce script a été créé à l'origine comme un projet d'apprentissage. Bien qu'il ait été revu pour être plus sûr, utilisez-le à vos propres risques. Je ne suis pas responsable des éventuels problèmes sur votre système.
