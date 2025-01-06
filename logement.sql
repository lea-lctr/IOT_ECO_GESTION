-- sqlite3 bibli.db
-- .read bibli.sql

-- commandes de destruction des tables
DROP TABLE IF EXISTS Logement;
DROP TABLE IF EXISTS Piece;
DROP TABLE IF EXISTS CapteurActionneur;
DROP TABLE IF EXISTS TypeCapteurActionneur;
DROP TABLE IF EXISTS Mesure;
DROP TABLE IF EXISTS Facture;
DROP TABLE IF EXISTS Envois;

-- commandes de creation des tables
CREATE TABLE Logement ( id_logement INTEGER PRIMARY KEY, 
                        adresse TEXT NOT NULL, 
                        numero_telephone TEXT NOT NULL, 
                        adresse_ip TEXT NOT NULL, 
                        date_insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE Piece (    id_piece  INTEGER PRIMARY KEY, 
                        Nom TEXT NOT NULL, 
                        coordonnees TEXT NOT NULL, 
                        id_logement INTEGER, 
                        FOREIGN KEY (id_logement) REFERENCES Logement(id_logement));

CREATE TABLE TypeCapteurActionneur (id_type  INTEGER PRIMARY KEY, 
                                    nom TEXT NOT NULL, 
                                    unite_mesure TEXT NOT NULL, 
                                    precision_min REAL, 
                                    precision_max REAL);

CREATE TABLE CapteurActionneur (    id_capteur_actionneur INTEGER PRIMARY KEY, 
                                    id_type INTEGER, 
                                    reference_commerciale TEXT NOT NULL, 
                                    id_piece INTEGER, 
                                    port TEXT NOT NULL, 
                                    date_insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    FOREIGN KEY (id_piece) REFERENCES Piece(id_piece), 
                                    FOREIGN KEY (id_type) REFERENCES TypeCapteurActionneur(id_type)); 

CREATE TABLE Mesure (   id_mesure  INTEGER PRIMARY KEY, 
                        id_capteur_actionneur INTEGER, 
                        valeur INTEGER,
                        date_insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (id_capteur_actionneur) REFERENCES CapteurActionneur(id_capteur_actionneur));

CREATE TABLE Facture (  id_facture INTEGER PRIMARY KEY, 
                        type_facture TEXT NOT NULL, 
                        dates TEXT NOT NULL, 
                        montant REAL, 
                        valeur_consommée REAL, 
                        id_logement INTEGER, 
                        FOREIGN KEY (id_logement) REFERENCES Logement(id_logement));

-- insertion de données
INSERT INTO Logement VALUES (1, 'Jussieu Sorbonne', '0778453904', '19.255.255.109', '10/04/2023');

INSERT INTO Piece VALUES    (2, 'Salon', '0001', 1), 
                            (3, 'Cuisine', '0010', 1), 
                            (4, 'Salle De Bain', '0011', 1), 
                            (5, 'Jardin', '0100', 1);


-- Insertion de types de capteurs et actionneurs
INSERT INTO TypeCapteurActionneur VALUES
(10, 'Capteur de température', '°C', -40.0, 125.0),
(11, 'Capteur d’humidité', '%', 0.0, 100.0),
(12, 'Capteur de luminosité', 'lux', 0.0, 100000.0),
(14, 'Capteur de qualité d’air', 'ppm', 0.0, 5000.0),
(15, 'Capteur de pression', 'hPa', 300.0, 1100.0),
(16, 'Capteur de mouvement', '-', 0.0, 1.0),
(17, 'Niveau d’eau', 'cm', 0.0, 500.0),
(18, 'Capteur de CO2', 'ppm', 0.0, 2000.0),
(19, 'Vitesse de vent', 'm/s', 0.0, 60.0);

-- Insertion de capteurs et actionneurs
INSERT INTO CapteurActionneur VALUES
-- Pièce 1 : Salon
(20, 10, 'TMP102', 2, 'PORT_A1', '2023/01/01'), -- Capteur de température
(21, 11, 'DHT22', 2, 'PORT_A2', '2023/01/01'), -- Capteur d'humidité
(22, 12, 'LUX001', 2, 'PORT_A3', '2023/01/01'), -- Capteur de luminosité

-- Pièce 2 : Cuisine
(24, 10, 'TMP117', 3, 'PORT_B1', '2023/01/02'), -- Capteur de température
(25, 14, 'AIRQ100', 3, 'PORT_B2', '2023/01/02'), -- Capteur de qualité d’air
(26, 17, 'WATERLVL100', 3, 'PORT_B3', '2023/01/02'), -- Capteur de niveau d’eau

-- Pièce 3 : Salle de bain
(28, 10, 'TMP36', 4, 'PORT_C1', '2023/01/03'), -- Capteur de température
(29, 11, 'DHT11', 4, 'PORT_C2', '2023/01/03'), -- Capteur d'humidité
(30, 17, 'WATERLVL200', 4, 'PORT_C3', '2023/01/03'), -- Capteur de niveau d’eau
(31, 15, 'PRESS100', 4, 'PORT_C4', '2023/01/03'), -- Capteur de pression

-- Pièce 4 : Jardin
(32, 12, 'LUX002', 5, 'PORT_D1', '2023/01/04'), -- Capteur de luminosité
(33, 18, 'CO2METER200', 5, 'PORT_D2', '2023/01/04'), -- Capteur de CO2
(34, 19, 'WINDSPD100', 5, 'PORT_D3', '2023/01/04'), -- Capteur de vitesse de vent
(35, 16, 'PIR200', 5, 'PORT_D4', '2023/01/04'); -- Capteur de mouvement


-- Mesures pour le capteur TMP102 (Salon, Température)
INSERT INTO Mesure VALUES
(1, 20, 22, '2023/01/01'),
(2, 20, 23, '2023/01/02'),
(3, 20, 21, '2023/01/03'),
(4, 20, 22, '2023/01/04'),
(5, 20, 24, '2023/01/05'),

-- Mesures pour le capteur DHT22 (Salon, Humidité)
(6, 21, 45, '2023/01/01'),
(7, 21, 46, '2023/01/02'),
(8, 21, 47, '2023/01/03'),
(9, 21, 48, '2023/01/04'),
(10, 21, 49, '2023/01/05'),

-- Mesures pour le capteur LUX001 (Salon, Luminosité)
(11, 22, 500, '2023/01/01'),
(12, 22, 520, '2023/01/02'),
(13, 22, 540, '2023/01/03'),
(14, 22, 560, '2023/01/04'),
(15, 22, 580, '2023/01/05'),

-- Mesures pour le capteur TMP117 (Cuisine, Température)
(16, 24, 23, '2023/01/02'),
(17, 24, 24, '2023/01/03'),
(18, 24, 25, '2023/01/04'),
(19, 24, 22, '2023/01/05'),
(20, 24, 23, '2023/01/06'),

-- Mesures pour le capteur AIRQ100 (Cuisine, Qualité d’air)
(21, 25, 15, '2023/01/02'),
(22, 25, 17, '2023/01/03'),
(23, 25, 16, '2023/01/04'),
(24, 25, 18, '2023/01/05'),
(25, 25, 19, '2023/01/06'),

-- Mesures pour le capteur WATERLVL100 (Cuisine, Niveau d’eau)

(26, 26, 150, '2023/01/02'),
(27, 26, 148, '2023/01/03'),
(28, 26, 147, '2023/01/04'),
(29, 26, 145, '2023/01/05'),
(30, 26, 140, '2023/01/06'),

-- Mesures pour le capteur TMP36 (Salle de bain, Température)
(31, 28, 21, '2023/01/03'),
(32, 28, 22, '2023/01/04'),
(33, 28, 20, '2023/01/05'),
(34, 28, 21, '2023/01/06'),
(35, 28, 23, '2023/01/07'),

-- Mesures pour le capteur DHT11 (Salle de bain, Humidité)
(36, 29, 55, '2023/01/03'),
(37, 29, 57, '2023/01/04'),
(38, 29, 56, '2023/01/05'),
(39, 29, 58, '2023/01/06'),
(40, 29, 59, '2023/01/07'),

-- Mesures pour le capteur WATERLVL200 (Salle de bain, Niveau d’eau)
(61, 30, 130, '2023/01/03'), -- Niveau d'eau en cm
(62, 30, 128, '2023/01/04'),
(63, 30, 127, '2023/01/05'),
(64, 30, 125, '2023/01/06'),
(65, 30, 123, '2023/01/07'),

-- Mesures pour le capteur PRESS100 (Salle de bain, Pression atmosphérique)
(66, 31, 1013, '2023/01/03'), -- Pression en hPa
(67, 31, 1014, '2023/01/04'),
(68, 31, 1012, '2023/01/05'),
(69, 31, 1015, '2023/01/06'),
(70, 31, 1011, '2023/01/07'),


-- Mesures pour le capteur LUX002 (Jardin, Luminosité)
(41, 32, 450, '2023/01/04'),
(42, 32, 470, '2023/01/05'),
(43, 32, 490, '2023/01/06'),
(44, 32, 510, '2023/01/07'),
(45, 32, 530, '2023/01/08'),

-- Mesures pour le capteur CO2METER200 (Jardin, CO2)
(46, 33, 400, '2023/01/04'),
(47, 33, 420, '2023/01/05'),
(48, 33, 430, '2023/01/06'),
(49, 33, 440, '2023/01/07'),
(50, 33, 450, '2023/01/08'),

-- Mesures pour le capteur WINDSPD100 (Jardin, Vitesse du vent)
(51, 34, 10, '2023/01/04'),
(52, 34, 12, '2023/01/05'),
(53, 34, 11, '2023/01/06'),
(54, 34, 13, '2023/01/07'),
(55, 34, 14, '2023/01/08'),

-- Mesures pour le capteur PIR200 (Jardin, Mouvement détecté)
(56, 35, 1, '2023/01/04'),
(57, 35, 0, '2023/01/05'),
(58, 35, 1, '2023/01/06'),
(59, 35, 0, '2023/01/07'),
(60, 35, 1, '2023/01/08');

-- Associations
CREATE TABLE Envois (id_logement INTEGER, 
                    id_facture INTEGER, 
                    FOREIGN KEY (id_logement) REFERENCES Logement(id_logement), 
                    FOREIGN KEY (id_facture) REFERENCES Facture(id_facture));


-- Associations supplémentaires pour la table Envois
INSERT INTO Envois VALUES 
(1, 20), -- Associe le logement 1 à la facture 20 (Electricité, Janvier 2022)
(1, 21), -- Associe le logement 1 à la facture 21 (Eau, Janvier 2022)
(1, 22), -- Associe le logement 1 à la facture 22 (Gaz, Janvier 2022)
(1, 23), -- Associe le logement 1 à la facture 23 (Electricité, Février 2022)
(1, 24), -- Associe le logement 1 à la facture 24 (Eau, Février 2022)
(1, 25), -- Associe le logement 1 à la facture 25 (Gaz, Février 2022)
(1, 26), -- Associe le logement 1 à la facture 26 (Electricité, Mars 2022)
(1, 27), -- Associe le logement 1 à la facture 27 (Eau, Mars 2022)
(1, 28), -- Associe le logement 1 à la facture 28 (Gaz, Mars 2022)
(1, 29), -- Associe le logement 1 à la facture 29 (Electricité, Avril 2022)
(1, 30), -- Associe le logement 1 à la facture 30 (Eau, Avril 2022)
(1, 31), -- Associe le logement 1 à la facture 31 (Gaz, Avril 2022)
(1, 32), -- Associe le logement 1 à la facture 32 (Electricité, Mai 2022)
(1, 33), -- Associe le logement 1 à la facture 33 (Eau, Mai 2022)
(1, 34), -- Associe le logement 1 à la facture 34 (Gaz, Mai 2022)
(1, 35), -- Associe le logement 1 à la facture 35 (Electricité, Juin 2022)
(1, 36), -- Associe le logement 1 à la facture 36 (Eau, Juin 2022)
(1, 37), -- Associe le logement 1 à la facture 37 (Gaz, Juin 2022)
(1, 38), -- Associe le logement 1 à la facture 38 (Electricité, Juillet 2022)
(1, 39), -- Associe le logement 1 à la facture 39 (Eau, Juillet 2022)
(1, 40), -- Associe le logement 1 à la facture 40 (Gaz, Juillet 2022)
(1, 41), -- Associe le logement 1 à la facture 41 (Electricité, Août 2022)
(1, 42), -- Associe le logement 1 à la facture 42 (Eau, Août 2022)
(1, 43), -- Associe le logement 1 à la facture 43 (Gaz, Août 2022)
(1, 44), -- Associe le logement 1 à la facture 44 (Electricité, Septembre 2022)
(1, 45), -- Associe le logement 1 à la facture 45 (Eau, Septembre 2022)
(1, 46), -- Associe le logement 1 à la facture 46 (Gaz, Septembre 2022)
(1, 47), -- Associe le logement 1 à la facture 47 (Electricité, Octobre 2022)
(1, 48), -- Associe le logement 1 à la facture 48 (Eau, Octobre 2022)
(1, 49), -- Associe le logement 1 à la facture 49 (Gaz, Octobre 2022)
(1, 50), -- Associe le logement 1 à la facture 50 (Electricité, Novembre 2022)
(1, 51), -- Associe le logement 1 à la facture 51 (Eau, Novembre 2022)
(1, 52), -- Associe le logement 1 à la facture 52 (Gaz, Novembre 2022)
(1, 53), -- Associe le logement 1 à la facture 53 (Electricité, Décembre 2022)
(1, 54), -- Associe le logement 1 à la facture 54 (Eau, Décembre 2022)
(1, 55); -- Associe le logement 1 à la facture 55 (Gaz, Décembre 2022)



INSERT INTO Facture VALUES
-- Année 2022
(20, 'Electricite', '2022/01/15', 120.00, 300.0, 1),
(21, 'Eau',         '2022/01/15', 20.00, 4.0, 1),
(22, 'Gaz',         '2022/01/15', 50.00, 150.0, 1),

(23, 'Electricite', '2022/02/15', 115.00, 290.0, 1),
(24, 'Eau',         '2022/02/15', 22.00, 5.0, 1),
(25, 'Gaz',         '2022/02/15', 55.00, 160.0, 1),

(26, 'Electricite', '2022/03/15', 120.00, 300.0, 1),
(27, 'Eau',         '2022/03/15', 21.00, 4.8, 1),
(28, 'Gaz',         '2022/03/15', 53.00, 155.0, 1),

(29, 'Electricite', '2022/04/15', 125.00, 310.0, 1),
(30, 'Eau',         '2022/04/15', 23.00, 5.2, 1),
(31, 'Gaz',         '2022/04/15', 52.00, 153.0, 1),

(32, 'Electricite', '2022/05/15', 120.00, 295.0, 1),
(33, 'Eau',         '2022/05/15', 22.50, 5.1, 1),
(34, 'Gaz',         '2022/05/15', 50.00, 150.0, 1),

(35, 'Electricite', '2022/06/15', 118.00, 290.0, 1),
(36, 'Eau',         '2022/06/15', 24.00, 5.5, 1),
(37, 'Gaz',         '2022/06/15', 55.00, 160.0, 1),

(38, 'Electricite', '2022/07/15', 122.00, 305.0, 1),
(39, 'Eau',         '2022/07/15', 23.50, 5.3, 1),
(40, 'Gaz',         '2022/07/15', 58.00, 165.0, 1),

(41, 'Electricite', '2022/08/15', 120.00, 300.0, 1),
(42, 'Eau',         '2022/08/15', 21.50, 4.9, 1),
(43, 'Gaz',         '2022/08/15', 52.00, 152.0, 1),

(44, 'Electricite', '2022/09/15', 123.00, 308.0, 1),
(45, 'Eau',         '2022/09/15', 22.00, 5.0, 1),
(46, 'Gaz',         '2022/09/15', 54.00, 158.0, 1),

(47, 'Electricite', '2022/10/15', 119.00, 295.0, 1),
(48, 'Eau',         '2022/10/15', 23.00, 5.3, 1),
(49, 'Gaz',         '2022/10/15', 56.00, 162.0, 1),

(50, 'Electricite', '2022/11/15', 125.00, 310.0, 1),
(51, 'Eau',         '2022/11/15', 24.50, 5.7, 1),
(52, 'Gaz',         '2022/11/15', 55.00, 160.0, 1),

(53, 'Electricite', '2022/12/15', 123.00, 305.0, 1),
(54, 'Eau',         '2022/12/15', 25.00, 5.8, 1),
(55, 'Gaz',         '2022/12/15', 57.00, 163.0, 1),

-- Année 2023
(56, 'Electricite', '2023/01/15', 122.00, 303.0, 1),
(57, 'Eau',         '2023/01/15', 23.00, 5.4, 1),
(58, 'Gaz',         '2023/01/15', 55.00, 160.0, 1),

(59, 'Electricite', '2023/02/15', 124.00, 308.0, 1),
(60, 'Eau',         '2023/02/15', 22.00, 5.0, 1),
(61, 'Gaz',         '2023/02/15', 53.00, 157.0, 1),

(62, 'Electricite', '2023/03/15', 120.00, 300.0, 1),
(63, 'Eau',         '2023/03/15', 24.00, 5.6, 1),
(64, 'Gaz',         '2023/03/15', 56.00, 162.0, 1),

(65, 'Electricite', '2023/04/15', 125.00, 312.0, 1),
(66, 'Eau',         '2023/04/15', 23.00, 5.3, 1),
(67, 'Gaz',         '2023/04/15', 58.00, 168.0, 1),

(68, 'Electricite', '2023/05/15', 122.00, 303.0, 1),
(69, 'Eau',         '2023/05/15', 24.50, 5.9, 1),
(70, 'Gaz',         '2023/05/15', 57.00, 165.0, 1),

(71, 'Electricite', '2023/06/15', 120.00, 298.0, 1),
(72, 'Eau',         '2023/06/15', 25.00, 6.0, 1),
(73, 'Gaz',         '2023/06/15', 59.00, 170.0, 1),

(74, 'Electricite', '2023/07/15', 118.00, 295.0, 1),
(75, 'Eau',         '2023/07/15', 23.00, 5.4, 1),
(76, 'Gaz',         '2023/07/15', 55.00, 160.0, 1),

(77, 'Electricite', '2023/08/15', 121.00, 301.0, 1),
(78, 'Eau',         '2023/08/15', 22.50, 5.1, 1),
(79, 'Gaz',         '2023/08/15', 54.00, 158.0, 1),

(80, 'Electricite', '2023/09/15', 124.00, 308.0, 1),
(81, 'Eau',         '2023/09/15', 24.00, 5.6, 1),
(82, 'Gaz',         '2023/09/15', 57.00, 163.0, 1),

(83, 'Electricite', '2023/10/15', 123.00, 306.0, 1),
(84, 'Eau',         '2023/10/15', 23.50, 5.4, 1),
(85, 'Gaz',         '2023/10/15', 55.00, 160.0, 1),

(86, 'Electricite', '2023/11/15', 120.00, 300.0, 1),
(87, 'Eau',         '2023/11/15', 22.50, 5.1, 1),
(88, 'Gaz',         '2023/11/15', 53.00, 157.0, 1),

(89, 'Electricite', '2023/12/15', 125.00, 312.0, 1),
(90, 'Eau',         '2023/12/15', 24.50, 5.9, 1),
(91, 'Gaz',         '2023/12/15', 57.00, 165.0, 1);



