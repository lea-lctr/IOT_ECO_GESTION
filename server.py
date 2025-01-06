from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import sqlite3

app = FastAPI()

# Fonction pour se connecter à la base SQLite
def get_db_connection():
    conn = sqlite3.connect('logement.db')
    conn.row_factory = sqlite3.Row
    return conn

# Endpoint pour la racine "/"
@app.get("/")
async def read_root():
    return {"message": "Bienvenue sur le serveur RESTful de l'application IoT!"}

# Endpoint pour ajouter une mesure
@app.post("/add_measure/")
async def add_measure(id_capteur_actionneur: int, valeur: int, date_insertion: str):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO Mesure (id_capteur_actionneur, valeur, date_insertion) VALUES (?, ?, ?)',
        (id_capteur_actionneur, valeur, date_insertion)
    )
    conn.commit()
    conn.close()
    return {"message": "Mesure ajoutée avec succès"}

# Endpoint pour lire les mesures
@app.get("/get_measures/")
async def get_measures():
    conn = get_db_connection()
    cursor = conn.cursor()
    measures = cursor.execute('SELECT * FROM Mesure').fetchall()
    conn.close()
    return {"measures": [dict(measure) for measure in measures]}

# Nouveau Endpoint pour afficher un camembert
@app.get("/chart/", response_class=HTMLResponse)
async def get_chart():
    # Connexion à la base de données
    conn = get_db_connection()
    cursor = conn.cursor()

    # Récupérer les types de factures et leurs montants
    factures = cursor.execute(
        'SELECT type_facture, SUM(montant) as total FROM Facture GROUP BY type_facture'
    ).fetchall()
    conn.close()

    # Préparer les données pour Google Charts
    data = [["Type de facture", "Montant"]]  # En-têtes
    for facture in factures:
        data.append([facture["type_facture"], facture["total"]])

    # Générer la page HTML
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Graphique des factures</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
            google.charts.load('current', {{packages: ['corechart']}});
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {{
                var data = google.visualization.arrayToDataTable({data});
                var options = {{
                    title: 'Répartition des factures',
                    is3D: true
                }};
                var chart = new google.visualization.PieChart(document.getElementById('piechart'));
                chart.draw(data, options);
            }}
        </script>
    </head>
    <body>
        <h1>Répartition des montants des factures</h1>
        <div id="piechart" style="width: 900px; height: 500px;"></div>
    </body>
    </html>
    """
    return HTMLResponse(content=html_content)

from fastapi.responses import HTMLResponse
import requests

# Endpoint pour récupérer les prévisions météo
@app.get("/weather/", response_class=HTMLResponse)
async def get_weather(city: str = "Massy"):
    # Clé API OpenWeatherMap
    api_key = "5a23cebf058b7f30fa448a9ccf75e5d3"
    url = f"https://api.openweathermap.org/data/2.5/forecast?q={city}&appid={api_key}&units=metric&lang=fr"

    try:
        # Requête vers l'API
        response = requests.get(url)
        response.raise_for_status()  # Vérifie les erreurs HTTP

        # Extraction des données météo
        weather_data = response.json()
        daily_forecasts = {}
        for forecast in weather_data["list"]:
            date = forecast["dt_txt"].split(" ")[0]  # Extraire la date (AAAA-MM-JJ)
            time = forecast["dt_txt"].split(" ")[1]  # Extraire l'heure

            # Prendre les prévisions autour de midi (12:00)
            if date not in daily_forecasts and "12:00:00" in time:
                daily_forecasts[date] = {
                    "datetime": forecast["dt_txt"],
                    "temperature": forecast["main"]["temp"],
                    "description": forecast["weather"][0]["description"]
                }

            # Arrêter une fois que nous avons 5 jours
            if len(daily_forecasts) == 5:
                break

        # Génération d'une page HTML pour afficher les données
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>Prévisions météo</title>
        </head>
        <body>
            <h1>Prévisions météo pour {city.capitalize()}</h1>
            <ul>
        """
        for date, forecast in daily_forecasts.items():
            html_content += f"<li>{forecast['datetime']} - {forecast['temperature']}°C - {forecast['description']}</li>"
        html_content += """
            </ul>
        </body>
        </html>
        """

        # Retourner le contenu HTML
        return HTMLResponse(content=html_content)

    except requests.RequestException as e:
        return {"error": "Impossible de récupérer les données météo", "details": str(e)}
