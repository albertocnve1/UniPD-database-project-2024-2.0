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


