# README - Projet IoT Logement Éco-Responsable

## Description du Projet
Ce projet vise à concevoir un système IoT complet pour la gestion d'un logement éco-responsable. Il inclut un site web interactif et un serveur backend permettant de superviser les consommations énergétiques, de configurer les capteurs et actionneurs, et d'afficher des économies réalisées.

## Fonctionnalités
- **Page d'accueil :** Accès rapide aux différentes sections (consommation, capteurs, économies, configuration).
- **Consommation :** Affichage des graphiques interactifs pour visualiser la consommation en électricité, eau et gaz.
- **Capteurs :** Vue d'ensemble des capteurs installés par pièce.
- **Économies :** Analyse des économies réalisées à travers des graphiques comparatifs.
- **Configuration :**
  - Authentification (Identifiant: "Léa", Mot de passe: "Lacouture").
  - Gestion des logements, pièces et capteurs.
  - Ajout dynamique de capteurs et de pièces.

## Installation et Configuration

### Prérequis
- Python 3.9 ou version ultérieure
- SQLite3
- Modules Python : `fastapi`, `uvicorn`, `sqlite3`, `jinja2` (installer avec pip si nécessaire)

### Installation
1. Clonez le dépôt :
   ```bash
   git clone <URL_DU_DEPOT>
   cd Projet-IoT
   ```
2. Installez les dépendances Python :
   ```bash
   pip install fastapi uvicorn
   ```

3. La base de données `logement.db` est placée dans le dossier `database/`.

### Démarrage du Serveur
Lancez le serveur backend avec Uvicorn :
```bash
uvicorn server.db_server:app --reload
```

Le serveur sera accessible à l'adresse : `http://127.0.0.1:8000`

Pour tester les endpoints, rendez-vous sur la documentation interactive :
`http://127.0.0.1:8000/docs`

### Accéder au Site Web
1. Ouvrez le fichier `acceuil/acceuil.html` dans un navigateur web.

## Explications des Différentes Parties
Chaque partie du projet est documentée dans un fichier dédié :

- **Partie Accueil :** Voir `README_Accueil.txt` : [README_Accueil.txt](https://github.com/user-attachments/files/18391699/README_Accueil.txt)
- **Partie Consommation :** Voir `README_Conso.txt` : [README_Conso.txt](https://github.com/user-attachments/files/18391702/README_Conso.txt)
- **Partie Capteurs :** Voir `README_Capteur.txt` : [README_Capteur.txt](https://github.com/user-attachments/files/18391700/README_Capteur.txt)
- **Partie Économies :** Voir `README_Eco.txt` : [README_Eco.txt](https://github.com/user-attachments/files/18391703/README_Eco.txt)
- **Partie Configuration :** Voir `README_Conf.txt` : [README_Conf.txt](https://github.com/user-attachments/files/18391701/README_Conf.txt)
- **Code Backend :** Voir `README_Server.txt` : [README_server.txt](https://github.com/user-attachments/files/18391698/README_server.txt)

## Sources Utilisées
- ChatGPT (OpenAI) pour la génération du code HTML, la correction de code et l'optimisation de code.
- Documentation officielle de FastAPI : [https://fastapi.tiangolo.com/](https://fastapi.tiangolo.com/)
- Documentation officielle de Bootstrap : [https://getbootstrap.com/](https://getbootstrap.com/)

## Auteur
Léa Lacouture
