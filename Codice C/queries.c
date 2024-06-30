#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libpq-fe.h"

#define PG_HOST "localhost"
#define PG_USER "albertocanavese"
#define PG_DB "videoteche"
#define PG_PASS "" 
#define PG_PORT "5432"

void exit_nicely(PGconn *conn) {
    PQfinish(conn);
    exit(1);
}

PGconn* connect() {
    char conninfo[256];
    sprintf(conninfo, "host=%s user=%s dbname=%s password=%s port=%s",
        PG_HOST, PG_USER, PG_DB, PG_PASS, PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        exit_nicely(conn);
    }

    return conn;
}

PGresult* execute(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Query failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit_nicely(conn);
    }

    return res;
}

void printLine(int campi, int* maxChar) {
    for (int j = 0; j < campi; ++j) {
        printf("+");
        for (int k = 0; k < maxChar[j] + 2; ++k)
            printf("-");
    }
    printf("+\n");
}

void printQuery(PGresult* res) {
    const int tuple = PQntuples(res), campi = PQnfields(res);
    char v[tuple + 1][campi][256];

    for (int i = 0; i < campi; ++i) {
        strcpy(v[0][i], PQfname(res, i));
    }
    for (int i = 0; i < tuple; ++i) {
        for (int j = 0; j < campi; ++j) {
            strcpy(v[i + 1][j], PQgetvalue(res, i, j));
        }
    }

    int maxChar[campi];
    for (int i = 0; i < campi; ++i) {
        maxChar[i] = 0;
    }

    for (int i = 0; i < campi; ++i) {
        for (int j = 0; j < tuple + 1; ++j) {
            int size = strlen(v[j][i]);
            maxChar[i] = size > maxChar[i] ? size : maxChar[i];
        }
    }

    printLine(campi, maxChar);
    for (int j = 0; j < campi; ++j) {
        printf("| %s", v[0][j]);
        for (int k = 0; k < maxChar[j] - (int)strlen(v[0][j]) + 1; ++k) // Casting a int
            printf(" ");
        if (j == campi - 1)
            printf("|");
    }
    printf("\n");
    printLine(campi, maxChar);

    for (int i = 1; i < tuple + 1; ++i) {
        for (int j = 0; j < campi; ++j) {
            printf("| %s", v[i][j]);
            for (int k = 0; k < maxChar[j] - (int)strlen(v[i][j]) + 1; ++k) // Casting a int
                printf(" ");
            if (j == campi - 1)
                printf("|");
        }
        printf("\n");
    }
    printLine(campi, maxChar);
}

char* chooseParam(PGconn* conn, const char* query, const char* table) {
    PGresult* res = execute(conn, query);
    printQuery(res);

    const int tuple = PQntuples(res);
    static char val[256];  // use static to keep the value in memory
    printf("Inserisci il nome della %s scelta: ", table);
    scanf("%s", val);

    for (int i = 0; i < tuple; ++i) {
        if (strcmp(val, PQgetvalue(res, i, 0)) == 0) {
            return val;  // return the static value
        }
    }
    printf("Valore non valido\n");
    return NULL;
}

int main() {
    PGconn* conn = connect();

    const char* query[6] = {
        "SELECT Gestore.Nome AS Gestore, Videoteca.Nome AS Videoteca, Videoteca.Nome_comune, Comune.Numero_abitanti \
         FROM Gestore \
         JOIN Videoteca ON Gestore.P_IVA_videoteca = Videoteca.P_IVA \
         JOIN Comune ON Videoteca.Nome_comune = Comune.Nome \
         WHERE Comune.Numero_abitanti > %s \
         ORDER BY Comune.Numero_abitanti ASC;",

        "SELECT Fornitore.Nome AS Fornitore, Regista.Nome AS Regista, DVD.Titolo AS Titolo \
         FROM Regista \
         JOIN DVD ON Regista.CF = DVD.CF_regista \
         JOIN Fornitore ON DVD.Nome_fornitore = Fornitore.Nome \
         WHERE DVD.Minuti > %s;",

        "SELECT Fornitore.Nome, COUNT(DVD.ID) AS Numero_DVD \
         FROM Fornitore \
         JOIN DVD ON Fornitore.Nome = DVD.Nome_fornitore \
         GROUP BY Fornitore.Nome \
         HAVING COUNT(DVD.ID) > 1;",

        "SELECT Carta_di_credito.Numero, Cliente.CF \
         FROM Carta_di_credito \
         JOIN Cliente ON Carta_di_credito.CF_cliente = Cliente.CF \
         GROUP BY Carta_di_credito.Numero, Cliente.CF \
         HAVING COUNT(DISTINCT Carta_di_credito.Numero) > 0;",

        "SELECT Cliente.Nome_comune, Cliente.CF \
         FROM Cliente \
         JOIN Scarica ON Cliente.CF = Scarica.CF_cliente \
         JOIN File ON Scarica.ID_film = File.ID \
         WHERE File.Lingua <> Cliente.Nazionalita \
         GROUP BY Cliente.Nome_comune, Cliente.CF \
         ORDER BY Cliente.Nome_comune;",

        "SELECT Cineforum.Data, Cineforum.Titolo_film, Videoteca.Nome, Videoteca.Orario_apertura \
         FROM Cineforum \
         JOIN Propone ON Cineforum.Data = Propone.Data AND Cineforum.Titolo_film = Propone.Titolo_film \
         JOIN Videoteca ON Propone.P_IVA_videoteca = Videoteca.P_IVA \
         WHERE Videoteca.Orario_apertura < '%s';"
    };

    while (1) {
        printf("\n");
        printf("1. Tutti i gestori che lavorano in videoteche situate in comuni con più di un certo numero di abitanti\n");
        printf("2. Tutti i registi che hanno diretto DVD con più di un certo numero di minuti e i loro rispettivi fornitori\n");
        printf("3. Tutti i fornitori che consegnano più di un DVD\n");
        printf("4. Raggruppa i numeri delle carte di credito e stampa i CF dei clienti che hanno più di una carta\n");
        printf("5. CF dei clienti che hanno scaricato un file in una lingua diversa dalla loro nazionalità, raggruppati per comune di residenza\n");
        printf("6. Cineforum organizzati in videoteche con orari di apertura precedenti ad un certo orario\n");
        printf("Query da eseguire (0 per uscire): ");
        int q = 0;
        scanf("%d", &q);
        while (q < 0 || q > 6) {
            printf("Le query vanno da 1 a 6...\n");
            printf("Query da eseguire (0 per uscire): ");
            scanf("%d", &q);
        }
        if (q == 0) break;
        char queryTemp[1500];

        switch (q) {
        case 1: {
            char abitanti[6];
            printf("Inserisci il numero di abitanti: ");
            scanf("%s", abitanti);
            sprintf(queryTemp, query[0], abitanti);
            printQuery(execute(conn, queryTemp));
            break;
        }
        case 2: {
            char minuti[4];
            printf("Inserisci il numero di minuti: ");
            scanf("%s", minuti);
            sprintf(queryTemp, query[1], minuti);
            printQuery(execute(conn, queryTemp));
            break;
        }
        case 6: {
            char orario[6];
            printf("Inserisci l'orario di apertura (HH:MM): ");
            scanf("%s", orario);
            sprintf(queryTemp, query[5], orario);
            printQuery(execute(conn, queryTemp));
            break;
        }
        default:
            printQuery(execute(conn, query[q - 1]));
            break;
        }
    }

    PQfinish(conn);
    return 0;
}
