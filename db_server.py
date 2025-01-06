from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import sqlite3

app = FastAPI()

# Configurer CORS pour permettre les requêtes depuis votre page HTML
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Autorise toutes les origines
    allow_methods=["*"],
    allow_headers=["*"],
)

# Fonction pour se connecter à la base SQLite
def get_db_connection():
    conn = sqlite3.connect('logement.db')
    conn.row_factory = sqlite3.Row
    return conn

# Endpoint pour récupérer les données de consommation
@app.get("/consumption/")
async def get_consumption():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Récupérer les données pour électricité, gaz et eau
    query = """
        SELECT type_facture, dates, montant
        FROM Facture
        WHERE type_facture IN ('Electricite', 'Gaz', 'Eau')
        ORDER BY dates
    """
    results = cursor.execute(query).fetchall()
    conn.close()

    # Transformer les données en format JSON
    data = {
        "Electricite": [],
        "Gaz": [],
        "Eau": []
    }
    for row in results:
        data[row["type_facture"]].append({
            "date": row["dates"],
            "montant": row["montant"]
        })

    return data

# Fonction pour se connecter à la base SQLite
def get_db_connection():
    conn = sqlite3.connect('logement.db')
    conn.row_factory = sqlite3.Row
    return conn

# Endpoint pour récupérer toutes les pièces
@app.get("/pieces/")
async def get_pieces():
    conn = get_db_connection()
    cursor = conn.cursor()
    pieces = cursor.execute("SELECT * FROM Piece").fetchall()
    conn.close()
    return {"pieces": [dict(piece) for piece in pieces]}

# Endpoint pour récupérer les capteurs d'une pièce donnée
@app.get("/capteurs/{piece_id}")
async def get_capteurs(piece_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    capteurs = cursor.execute(
        "SELECT * FROM CapteurActionneur WHERE id_piece = ?", (piece_id,)
    ).fetchall()
    conn.close()
    return {"capteurs": [dict(capteur) for capteur in capteurs]}

@app.get("/pieces/{piece_id}/capteurs/")
async def get_capteurs_for_piece(piece_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Récupérer les capteurs de la pièce
    capteurs = cursor.execute("""
        SELECT c.id_capteur_actionneur, c.reference_commerciale, t.nom AS type_capteur
        FROM CapteurActionneur c
        JOIN TypeCapteurActionneur t ON c.id_type = t.id_type
        WHERE c.id_piece = ?
    """, (piece_id,)).fetchall()

    # Récupérer les mesures pour chaque capteur
    result = []
    for capteur in capteurs:
        capteur_id = capteur["id_capteur_actionneur"]
        mesures = cursor.execute("""
            SELECT valeur, date_insertion
            FROM Mesure
            WHERE id_capteur_actionneur = ?
        """, (capteur_id,)).fetchall()

        result.append({
            "reference": capteur["reference_commerciale"],
            "type": capteur["type_capteur"],
            "mesures": [{"valeur": m["valeur"], "date": m["date_insertion"]} for m in mesures]
        })

    conn.close()
    return result

@app.get("/economies/")
async def get_economies():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Récupérer les montants des économies pour l'électricité
    cursor.execute("""
        SELECT dates, montant
        FROM Facture
        WHERE type_facture = 'Electricite'
        ORDER BY dates
    """)
    electricity = [{"date": row["dates"], "montant": row["montant"]} for row in cursor.fetchall()]

    # Récupérer les montants des économies pour l'eau
    cursor.execute("""
        SELECT dates, montant
        FROM Facture
        WHERE type_facture = 'Eau'
        ORDER BY dates
    """)
    water = [{"date": row["dates"], "montant": row["montant"]} for row in cursor.fetchall()]

    # Récupérer les montants des économies pour le gaz
    cursor.execute("""
        SELECT dates, montant
        FROM Facture
        WHERE type_facture = 'Gaz'
        ORDER BY dates
    """)
    gas = [{"date": row["dates"], "montant": row["montant"]} for row in cursor.fetchall()]

    conn.close()

    return {
        "Electricite": electricity,
        "Eau": water,
        "Gaz": gas
    }

@app.post("/add-capteur/")
async def add_capteur(capteur: dict):
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
        INSERT INTO CapteurActionneur (id_type, reference_commerciale, id_piece, port, date_insertion)
        VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
    """
    cursor.execute(query, (
        capteur["id_type"], 
        capteur["reference_commerciale"], 
        capteur["id_piece"], 
        capteur["port"]
    ))
    conn.commit()
    conn.close()

    return {"message": "Capteur ajouté avec succès"}

@app.get("/types/")
async def get_types():
    conn = get_db_connection()
    cursor = conn.cursor()
    types = cursor.execute("SELECT id_type, nom FROM TypeCapteurActionneur").fetchall()
    conn.close()
    return [{"id_type": t["id_type"], "nom": t["nom"]} for t in types]

@app.post("/add-piece/")
async def add_piece(piece: dict):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        query = """
        INSERT INTO Piece (id_piece, Nom, coordonnees, id_logement)
        VALUES (?, ?, ?, ?)
        """
        cursor.execute(query, (
            piece["id_piece"],
            piece["Nom"],
            piece["coordonnees"],
            piece["id_logement"]
        ))
        conn.commit()
        return {"message": "Pièce ajoutée avec succès"}
    except sqlite3.Error as e:
        return {"detail": f"Erreur lors de l'ajout de la pièce : {str(e)}"}
    finally:
        conn.close()

@app.get("/logements/")
async def get_logements():
    conn = get_db_connection()
    cursor = conn.cursor()
    logements = cursor.execute("SELECT * FROM Logement").fetchall()
    conn.close()
    return {"logements": [dict(logement) for logement in logements]}

