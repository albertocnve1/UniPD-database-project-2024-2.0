DROP TABLE IF EXISTS Propone;
DROP TABLE IF EXISTS Scarica;
DROP TABLE IF EXISTS Noleggia;
DROP TABLE IF EXISTS Danneggia;
DROP TABLE IF EXISTS Carta_di_credito;
DROP TABLE IF EXISTS Cineforum;
DROP TABLE IF EXISTS File;
DROP TABLE IF EXISTS DVD;
DROP TABLE IF EXISTS Gestore;
DROP TABLE IF EXISTS Videoteca;
DROP TABLE IF EXISTS Fornitore;
DROP TABLE IF EXISTS Regista;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Comune;

-- Comune
CREATE TABLE IF NOT EXISTS Comune (
    Nome VARCHAR(100) PRIMARY KEY,
    Provincia VARCHAR(100) NOT NULL,
    Numero_abitanti INT NOT NULL
);

-- Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Data_di_nascita DATE NOT NULL,
    Nazionalita VARCHAR(50) NOT NULL,
    Nome_comune VARCHAR(100) NOT NULL,
    FOREIGN KEY (Nome_comune) REFERENCES Comune(Nome)
);

-- Regista
CREATE TABLE IF NOT EXISTS Regista (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Data_di_nascita DATE NOT NULL,
    Nazionalita VARCHAR(50) NOT NULL,
    Nome_comune VARCHAR(100) NOT NULL,
    FOREIGN KEY (Nome_comune) REFERENCES Comune(Nome)
);

-- Fornitore
CREATE TABLE IF NOT EXISTS Fornitore (
    Nome VARCHAR(100) PRIMARY KEY,
    Sede_centrale VARCHAR(255) NOT NULL
);

-- Videoteca
CREATE TABLE IF NOT EXISTS Videoteca (
    P_IVA VARCHAR(11) PRIMARY KEY,
    Nome VARCHAR(100) UNIQUE NOT NULL,
    Orario_apertura TIME NOT NULL,
    Orario_chiusura TIME NOT NULL,
    Indirizzo VARCHAR(255) NOT NULL,
    Nome_comune VARCHAR(100) NOT NULL,
    FOREIGN KEY (Nome_comune) REFERENCES Comune(Nome)
);

-- Gestore
CREATE TABLE IF NOT EXISTS Gestore (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Data_di_nascita DATE NOT NULL,
    Nazionalita VARCHAR(50) NOT NULL,
    Nome_comune VARCHAR(100) NOT NULL,
    P_IVA_videoteca VARCHAR(11) NOT NULL,
    FOREIGN KEY (Nome_comune) REFERENCES Comune(Nome),
    FOREIGN KEY (P_IVA_videoteca) REFERENCES Videoteca(P_IVA)
);

-- DVD
CREATE TABLE IF NOT EXISTS DVD (
    ID VARCHAR(100) PRIMARY KEY,
    Titolo VARCHAR(255) NOT NULL,
    Genere VARCHAR(100) NOT NULL,
    Lingua VARCHAR(50) NOT NULL,
    Minuti INT NOT NULL,
    Anno INT NOT NULL,
    CF_cliente VARCHAR(16),
    CF_regista VARCHAR(16) NOT NULL,
    Nome_fornitore VARCHAR(100) NOT NULL,
    Nome_videoteca VARCHAR(100) NOT NULL,
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF),
    FOREIGN KEY (CF_regista) REFERENCES Regista(CF),
    FOREIGN KEY (Nome_fornitore) REFERENCES Fornitore(Nome),
    FOREIGN KEY (Nome_videoteca) REFERENCES Videoteca(Nome)
);

-- File
CREATE TABLE IF NOT EXISTS File (
    ID VARCHAR(100) PRIMARY KEY,
    Titolo VARCHAR(255) NOT NULL,
    Genere VARCHAR(100) NOT NULL,
    Lingua VARCHAR(50) NOT NULL,
    Minuti INT NOT NULL,
    Anno INT NOT NULL,
    GB NUMERIC(5,2) NOT NULL,
    CF_cliente VARCHAR(16),
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF)
);

-- Danneggia
CREATE TABLE IF NOT EXISTS Danneggia (
    ID_copia VARCHAR(100) NOT NULL,
    CF_cliente VARCHAR(16) NOT NULL,
    FOREIGN KEY (ID_copia) REFERENCES DVD(ID),
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF),
    PRIMARY KEY (ID_copia, CF_cliente)
);

-- Carta di credito
CREATE TABLE IF NOT EXISTS Carta_di_credito (
    Numero VARCHAR(16) PRIMARY KEY,
    Data_di_scadenza DATE NOT NULL,
    CF_cliente VARCHAR(16) NOT NULL,
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF)
);

-- Cineforum
CREATE TABLE IF NOT EXISTS Cineforum (
    Data DATE NOT NULL,
    Titolo_film VARCHAR(255) NOT NULL,
    PRIMARY KEY (Data, Titolo_film)
);

-- Propone
CREATE TABLE IF NOT EXISTS Propone (
    P_IVA_videoteca VARCHAR(11) NOT NULL,
    Data DATE NOT NULL,
    Titolo_film VARCHAR(255) NOT NULL,
    FOREIGN KEY (P_IVA_videoteca) REFERENCES Videoteca(P_IVA),
    FOREIGN KEY (Data, Titolo_film) REFERENCES Cineforum(Data, Titolo_film),
    PRIMARY KEY (P_IVA_videoteca, Data, Titolo_film)
);

-- Scarica
CREATE TABLE IF NOT EXISTS Scarica (
    ID_film VARCHAR(100) NOT NULL,
    CF_cliente VARCHAR(16) NOT NULL,
    Data_inizio DATE NOT NULL,
    Data_scadenza DATE NOT NULL,
    FOREIGN KEY (ID_film) REFERENCES File(ID),
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF),
    PRIMARY KEY (ID_film, CF_cliente)
);

-- Noleggia
CREATE TABLE IF NOT EXISTS Noleggia (
    ID VARCHAR(100) NOT NULL,
    Data_inizio DATE NOT NULL,
    Data_fine DATE NOT NULL,
    CF_cliente VARCHAR(16) NOT NULL,
    FOREIGN KEY (ID) REFERENCES DVD(ID),
    FOREIGN KEY (CF_cliente) REFERENCES Cliente(CF),
    PRIMARY KEY (ID, CF_cliente)
);

-- Aggiungi i comuni mancanti nella tabella Comune
INSERT INTO Comune (Nome, Provincia, Numero_abitanti) VALUES 
('Ferrara', 'Ferrara', 132000),
('Bologna', 'Bologna', 391000),
('Parma', 'Parma', 198000),
('Firenze', 'Firenze', 382000),
('Sora', 'Frosinone', 26000);

-- Popola la tabella Cliente
INSERT INTO Cliente (CF, Nome, Data_di_nascita, Nazionalita, Nome_comune) VALUES 
('CF0010000000001', 'Mario Rossi', '1980-01-01', 'Italiana', 'Parma'),
('CF0020000000002', 'Luigi Bianchi', '1990-02-02', 'Italiana', 'Firenze'),
('CF0030000000003', 'Giulia Verdi', '1985-03-03', 'Italiana', 'Bologna'),
('CF0040000000004', 'Carla Neri', '1975-04-04', 'Italiana', 'Parma'),
('CF0050000000005', 'Paolo Gialli', '1982-05-05', 'Italiana', 'Firenze'),
('CF0060000000006', 'Anna Blu', '1988-06-06', 'Italiana', 'Bologna'),
('CF0070000000007', 'Roberto Nero', '1992-07-07', 'Italiana', 'Parma'),
('CF0080000000008', 'Elena Arancio', '1994-08-08', 'Italiana', 'Firenze'),
('CF0090000000009', 'Sara Verde', '1986-09-09', 'Italiana', 'Bologna'),
('CF0100000000010', 'Davide Giallo', '1983-10-10', 'Italiana', 'Parma'),
('CF0110000000011', 'Gianni Viola', '1981-11-11', 'Italiana', 'Firenze'),
('CF0120000000012', 'Lucia Rosa', '1989-12-12', 'Italiana', 'Bologna'),
('CF0130000000013', 'Marco Bianco', '1987-01-13', 'Italiana', 'Parma'),
('CF0140000000014', 'Sofia Celeste', '1991-02-14', 'Italiana', 'Firenze'),
('CF0150000000015', 'Antonio Rosso', '1984-03-15', 'Italiana', 'Bologna'),
('CF0160000000016', 'Francesca Nero', '1982-04-16', 'Italiana', 'Parma'),
('CF0170000000017', 'Giorgio Verde', '1985-05-17', 'Italiana', 'Firenze'),
('CF0180000000018', 'Chiara Blu', '1990-06-18', 'Italiana', 'Bologna'),
('CF0190000000019', 'Federico Giallo', '1983-07-19', 'Italiana', 'Parma'),
('CF0200000000020', 'Martina Viola', '1992-08-20', 'Italiana', 'Firenze');

-- Popola la tabella Regista
INSERT INTO Regista (CF, Nome, Data_di_nascita, Nazionalita, Nome_comune) VALUES 
('R0010000000001', 'Federico Fellini', '1920-01-20', 'Italiana', 'Firenze'),
('R0020000000002', 'Sergio Leone', '1929-01-03', 'Italiana', 'Firenze'),
('R0030000000003', 'Michelangelo Antonioni', '1912-09-29', 'Italiana', 'Ferrara'),
('R0040000000004', 'Dario Argento', '1940-09-07', 'Italiana', 'Firenze'),
('R0050000000005', 'Pier Paolo Pasolini', '1922-03-05', 'Italiana', 'Bologna'),
('R0060000000006', 'Bernardo Bertolucci', '1941-03-16', 'Italiana', 'Parma'),
('R0070000000007', 'Franco Zeffirelli', '1923-02-12', 'Italiana', 'Firenze'),
('R0080000000008', 'Luchino Visconti', '1906-11-02', 'Italiana', 'Parma'),
('R0090000000009', 'Vittorio De Sica', '1901-07-07', 'Italiana', 'Sora'),
('R0100000000010', 'Roberto Rossellini', '1906-05-08', 'Italiana', 'Firenze');

-- Popola la tabella Fornitore
INSERT INTO Fornitore (Nome, Sede_centrale) VALUES 
('Fornitore1', 'Parma'),
('Fornitore2', 'Firenze'),
('Fornitore3', 'Bologna');

-- Popola la tabella Videoteca
INSERT INTO Videoteca (P_IVA, Nome, Orario_apertura, Orario_chiusura, Indirizzo, Nome_comune) VALUES 
('00100000001', 'Videoteca Parma', '09:00', '18:00', 'Via Parma 1', 'Parma'),
('00200000002', 'Videoteca Firenze', '10:00', '19:00', 'Via Firenze 2', 'Firenze'),
('00300000003', 'Videoteca Bologna', '08:00', '17:00', 'Via Bologna 3', 'Bologna');

-- Popola la tabella Gestore
INSERT INTO Gestore (CF, Nome, Data_di_nascita, Nazionalita, Nome_comune, P_IVA_videoteca) VALUES 
('G0010000000001', 'Alessandro Neri', '1985-05-05', 'Italiana', 'Parma', '00100000001'),
('G0020000000002', 'Francesca Russo', '1988-08-08', 'Italiana', 'Firenze', '00200000002'),
('G0030000000003', 'Luca Moretti', '1992-09-09', 'Italiana', 'Bologna', '00300000003');

-- Popola la tabella DVD
INSERT INTO DVD (ID, Titolo, Genere, Lingua, Minuti, Anno, CF_regista, Nome_fornitore, Nome_videoteca) VALUES 
('D001', 'La Dolce Vita', 'Dramma', 'Italiano', 180, 1960, 'R0010000000001', 'Fornitore1', 'Videoteca Parma'),
('D002', 'Il Buono, Il Brutto, Il Cattivo', 'Western', 'Italiano', 161, 1966, 'R0020000000002', 'Fornitore2', 'Videoteca Firenze'),
('D003', 'L Avventura', 'Dramma', 'Italiano', 144, 1960, 'R0030000000003', 'Fornitore3', 'Videoteca Bologna'),
('D004', 'Profondo Rosso', 'Horror', 'Italiano', 126, 1975, 'R0040000000004', 'Fornitore1', 'Videoteca Parma'),
('D005', 'C Era una Volta in America', 'Dramma', 'Italiano', 229, 1984, 'R0020000000002', 'Fornitore2', 'Videoteca Firenze'),
('D006', 'Il Conformista', 'Dramma', 'Italiano', 107, 1970, 'R0060000000006', 'Fornitore3', 'Videoteca Bologna'),
('D007', 'La Strada', 'Dramma', 'Italiano', 108, 1954, 'R0010000000001', 'Fornitore1', 'Videoteca Parma'),
('D008', 'Amarcord', 'Commedia', 'Italiano', 123, 1973, 'R0010000000001', 'Fornitore1', 'Videoteca Parma'),
('D009', 'Riso Amaro', 'Dramma', 'Italiano', 108, 1949, 'R0090000000009', 'Fornitore2', 'Videoteca Firenze'),
('D010', 'Firenze Città Aperta', 'Dramma', 'Italiano', 103, 1945, 'R0100000000010', 'Fornitore2', 'Videoteca Firenze');

-- Popola la tabella File
INSERT INTO File (ID, Titolo, Genere, Lingua, Minuti, Anno, GB, CF_cliente) VALUES 
('F001', 'La Dolce Vita', 'Dramma', 'Italiano', 180, 1960, 4.5, 'CF0010000000001'),
('F002', 'Il Buono, Il Brutto, Il Cattivo', 'Western', 'Italiano', 161, 1966, 3.2, 'CF0020000000002'),
('F003', 'L Avventura', 'Dramma', 'Italiano', 144, 1960, 3.8, 'CF0030000000003'),
('F004', 'Profondo Rosso', 'Horror', 'Italiano', 126, 1975, 2.5, 'CF0040000000004'),
('F005', 'C Era una Volta in America', 'Dramma', 'Italiano', 229, 1984, 6.0, 'CF0050000000005'),
('F006', 'Il Conformista', 'Dramma', 'Italiano', 107, 1970, 4.0, 'CF0060000000006'),
('F007', 'La Strada', 'Dramma', 'Italiano', 108, 1954, 3.5, 'CF0070000000007'),
('F008', 'Amarcord', 'Commedia', 'Italiano', 123, 1973, 5.0, 'CF0080000000008'),
('F009', 'Riso Amaro', 'Dramma', 'Italiano', 108, 1949, 4.5, 'CF0090000000009'),
('F010', 'Firenze Città Aperta', 'Dramma', 'Italiano', 103, 1945, 3.0, 'CF0100000000010');

-- Popola la tabella Danneggia
INSERT INTO Danneggia (ID_copia, CF_cliente) VALUES 
('D001', 'CF0010000000001'),
('D002', 'CF0020000000002'),
('D003', 'CF0030000000003'),
('D004', 'CF0040000000004'),
('D005', 'CF0050000000005'),
('D006', 'CF0060000000006'),
('D007', 'CF0070000000007'),
('D008', 'CF0080000000008'),
('D009', 'CF0090000000009'),
('D010', 'CF0100000000010');

-- Popola la tabella Carta di credito
INSERT INTO Carta_di_credito (Numero, Data_di_scadenza, CF_cliente) VALUES 
('1234567812345678', '2025-12-31', 'CF0010000000001'),
('2345678923456789', '2024-11-30', 'CF0020000000002'),
('3456789034567890', '2026-10-29', 'CF0030000000003'),
('4567890145678901', '2023-09-28', 'CF0040000000004'),
('5678901256789012', '2027-08-27', 'CF0050000000005'),
('6789012367890123', '2025-08-26', 'CF0060000000006'),
('7890123478901234', '2023-07-25', 'CF0070000000007'),
('8901234589012345', '2026-06-24', 'CF0080000000008'),
('9012345690123456', '2027-05-23', 'CF0090000000009'),
('0123456701234567', '2024-04-22', 'CF0100000000010');

-- Popola la tabella Cineforum
INSERT INTO Cineforum (Data, Titolo_film) VALUES 
('2024-07-01', 'La Dolce Vita'),
('2024-07-15', 'Il Buono, Il Brutto, Il Cattivo'),
('2024-08-01', 'L Avventura'),
('2024-08-15', 'Profondo Rosso'),
('2024-09-01', 'C Era una Volta in America');

-- Popola la tabella Propone
INSERT INTO Propone (P_IVA_videoteca, Data, Titolo_film) VALUES 
('00100000001', '2024-07-01', 'La Dolce Vita'),
('00200000002', '2024-07-15', 'Il Buono, Il Brutto, Il Cattivo'),
('00300000003', '2024-08-01', 'L Avventura'),
('00100000001', '2024-08-15', 'Profondo Rosso'),
('00200000002', '2024-09-01', 'C Era una Volta in America');

-- Popola la tabella Scarica
INSERT INTO Scarica (ID_film, CF_cliente, Data_inizio, Data_scadenza) VALUES 
('F001', 'CF0010000000001', '2024-06-01', '2024-06-30'),
('F002', 'CF0020000000002', '2024-06-05', '2024-06-25'),
('F003', 'CF0030000000003', '2024-06-10', '2024-07-10'),
('F004', 'CF0040000000004', '2024-06-15', '2024-07-15'),
('F005', 'CF0050000000005', '2024-06-20', '2024-07-20'),
('F006', 'CF0060000000006', '2024-06-25', '2024-07-25'),
('F007', 'CF0070000000007', '2024-07-01', '2024-07-31'),
('F008', 'CF0080000000008', '2024-07-05', '2024-08-05'),
('F009', 'CF0090000000009', '2024-07-10', '2024-08-10'),
('F010', 'CF0100000000010', '2024-07-15', '2024-08-15');

-- Popola la tabella Noleggia
INSERT INTO Noleggia (ID, Data_inizio, Data_fine, CF_cliente) VALUES 
('D001', '2024-06-01', '2024-06-10', 'CF0010000000001'),
('D002', '2024-06-05', '2024-06-15', 'CF0020000000002'),
('D003', '2024-06-10', '2024-06-20', 'CF0030000000003'),
('D004', '2024-06-15', '2024-06-25', 'CF0040000000004'),
('D005', '2024-06-20', '2024-06-30', 'CF0050000000005'),
('D006', '2024-06-25', '2024-07-05', 'CF0060000000006'),
('D007', '2024-07-01', '2024-07-10', 'CF0070000000007'),
('D008', '2024-07-05', '2024-07-15', 'CF0080000000008'),
('D009', '2024-07-10', '2024-07-20', 'CF0090000000009'),
('D010', '2024-07-15', '2024-07-25', 'CF0100000000010'),
('D001', '2024-08-01', '2024-08-10', 'CF0110000000011'),
('D002', '2024-08-05', '2024-08-15', 'CF0120000000012'),
('D003', '2024-08-10', '2024-08-20', 'CF0130000000013'),
('D004', '2024-08-15', '2024-08-25', 'CF0140000000014'),
('D005', '2024-08-20', '2024-08-30', 'CF0150000000015'),
('D006', '2024-08-25', '2024-09-05', 'CF0160000000016'),
('D007', '2024-09-01', '2024-09-10', 'CF0170000000017'),
('D008', '2024-09-05', '2024-09-15', 'CF0180000000018'),
('D009', '2024-09-10', '2024-09-20', 'CF0190000000019'),
('D010', '2024-09-15', '2024-09-25', 'CF0200000000020'),
('D001', '2024-06-01', '2024-06-10', 'CF0040000000004'),
('D002', '2024-06-05', '2024-06-15', 'CF0050000000005'),
('D003', '2024-06-10', '2024-06-20', 'CF0060000000006'),
('D004', '2024-06-15', '2024-06-25', 'CF0070000000007'),
('D005', '2024-06-20', '2024-06-30', 'CF0080000000008'),
('D006', '2024-06-25', '2024-07-05', 'CF0090000000009'),
('D007', '2024-07-01', '2024-07-10', 'CF0100000000010'),
('D008', '2024-07-05', '2024-07-15', 'CF0110000000011'),
('D009', '2024-07-10', '2024-07-20', 'CF0120000000012'),
('D010', '2024-07-15', '2024-07-25', 'CF0130000000013'),
('D001', '2024-08-01', '2024-08-10', 'CF0140000000014'),
('D002', '2024-08-05', '2024-08-15', 'CF0150000000015'),
('D003', '2024-08-10', '2024-08-20', 'CF0160000000016'),
('D004', '2024-08-15', '2024-08-25', 'CF0170000000017'),
('D005', '2024-08-20', '2024-08-30', 'CF0180000000018'),
('D006', '2024-08-25', '2024-09-05', 'CF0190000000019'),
('D007', '2024-09-01', '2024-09-10', 'CF0200000000020'),
('D008', '2024-09-05', '2024-09-15', 'CF0010000000001'),
('D009', '2024-09-10', '2024-09-20', 'CF0020000000002'),
('D010', '2024-09-15', '2024-09-25', 'CF0030000000003'),
('D001', '2024-06-01', '2024-06-10', 'CF0050000000005'),
('D002', '2024-06-05', '2024-06-15', 'CF0060000000006'),
('D003', '2024-06-10', '2024-06-20', 'CF0070000000007'),
('D004', '2024-06-15', '2024-06-25', 'CF0080000000008'),
('D005', '2024-06-20', '2024-06-30', 'CF0090000000009'),
('D006', '2024-06-25', '2024-07-05', 'CF0100000000010'),
('D007', '2024-07-01', '2024-07-10', 'CF0110000000011'),
('D008', '2024-07-05', '2024-07-15', 'CF0120000000012'),
('D009', '2024-07-10', '2024-07-20', 'CF0130000000013'),
('D010', '2024-07-15', '2024-07-25', 'CF0140000000014');



-- QUERIES 
-- numero totale di noleggi effettuati in ciascuna videoteca
SELECT v.Nome AS Videoteca, COUNT(n.ID) AS Totale_Noleggi
FROM Noleggia n
JOIN DVD d ON n.ID = d.ID
JOIN Videoteca v ON d.Nome_videoteca = v.Nome
GROUP BY v.Nome
ORDER BY Totale_Noleggi DESC;


-- numero totale di DVD danneggiati per ciascun cliente.
SELECT c.Nome AS Cliente, COUNT(dg.ID_copia) AS Totale_Danneggiati
FROM Cliente c
JOIN Danneggia dg ON c.CF = dg.CF_cliente
GROUP BY c.Nome
ORDER BY Totale_Danneggiati DESC;


-- numero di film scaricati per ciascun cliente e l'importo totale di spazio occupato in GB
SELECT c.Nome AS Cliente, COUNT(s.ID_film) AS Totale_Scaricati, SUM(f.GB) AS Totale_GB
FROM Cliente c
JOIN Scarica s ON c.CF = s.CF_cliente
JOIN File f ON s.ID_film = f.ID
GROUP BY c.Nome
ORDER BY Totale_Scaricati DESC;

-- registi che hanno diretto più di un film insieme al numero totale di film diretti
SELECT r.Nome AS Regista, COUNT(d.ID) AS Totale_Film
FROM Regista r
JOIN DVD d ON r.CF = d.CF_regista
GROUP BY r.Nome
HAVING COUNT(d.ID) > 1
ORDER BY Totale_Film DESC;


-- numero medio di noleggi per cliente per ciascuna videoteca
SELECT v.Nome AS Videoteca, AVG(n.Noleggi_Per_Cliente) AS Media_Noleggi_Per_Cliente
FROM (
    SELECT c.CF, d.Nome_videoteca, COUNT(n.ID) AS Noleggi_Per_Cliente
    FROM Cliente c
    JOIN Noleggia n ON c.CF = n.CF_cliente
    JOIN DVD d ON n.ID = d.ID
    GROUP BY c.CF, d.Nome_videoteca
) AS n
JOIN Videoteca v ON n.Nome_videoteca = v.Nome
GROUP BY v.Nome
ORDER BY Media_Noleggi_Per_Cliente DESC;


-- Creazione dell'indice sulla tabella Noleggia per ottimizzare le ricerche di noleggi per DVD
CREATE INDEX idx_noleggia_id ON Noleggia (ID);

--Creazione dell'indice sulla tabella DVD per ottimizzare le ricerche di noleggi per videoteca
CREATE INDEX idx_dvd_id_nome_videoteca ON DVD (ID, Nome_videoteca);
