import sqlite3, random
from datetime import datetime, timedelta

# ouverture/initialisation de la base de donnee 
conn = sqlite3.connect('logement.db') #se connecte à la base logement.db créé par logement.sql, puis une fois connecté il peut exécuter des requêtes SQL (INSERT,SELECT,...)
conn.row_factory = sqlite3.Row
c = conn.cursor() # "c." agit comme un curseur 

# Ajout de mesures aléatoires dans la table Mesure
def ajouter_mesures():
    for _ in range(5): #créer 5 mesures
        id_capteur_actionneur = random.choice([10, 11])
        valeur = random.randint(10, 900) #Mesures entier entre 10 et 900
        date_insertion = datetime(random.randint(2000, 2024), random.randint(1, 12),random.randint(1, 28)).strftime('%Y/%m/%d')

        c.execute(
        'INSERT INTO Mesure (id_capteur_actionneur, valeur, date_insertion) VALUES (?, ?, ?)', #Les ? permettent d'insérer des valeurs dynamiquement
        (id_capteur_actionneur, valeur, date_insertion)
        )

# Ajout de facture aléatoires dans la table Mesure
def ajouter_factures():
    for _ in range(2): #créer 5 mesures
        type_facture = random.choice(['Electriite', 'Courant', 'Eau', 'Gaz'])
        dates = datetime(random.randint(2000, 2024), random.randint(1, 12),random.randint(1, 28)).strftime('%Y/%m/%d')
        montant = random.randint(1, 300)
        valeur_consommée = random.randint(1, 150)
        id_logement = 1
        
        c.execute(
        'INSERT INTO Facture (type_facture, dates, montant, valeur_consommée, id_logement) VALUES (?, ?, ?, ?, ?)', #Les ? permettent d'insérer des valeurs dynamiquement
        (type_facture, dates, montant, valeur_consommée, id_logement)
        )

# affichage d'une table
def lire_mesures():
    print("\nDonnées dans la tale Mesure :")
    for row in c.execute('SELECT * FROM Mesure'):
        print(dict(row))

def lire_factures():
    print("\nDonnées dans la table Facture :")
    for row in c.execute('SELECT * FROM Facture'):
        print(dict(row))

# Les fonctions d'ajout
ajouter_mesures()
ajouter_factures()

# Les fonctions de lecture
lire_mesures()
lire_factures()

# fermeture
conn.commit()
conn.close()