# Definizione delle variabili
CC = gcc
CFLAGS = -Wall -Wextra -g3
INCLUDES = -I/opt/homebrew/Cellar/postgresql@14/14.12/include/postgresql@14/server -I/opt/homebrew/Cellar/postgresql@14/14.12/include
LDFLAGS = -L/opt/homebrew/lib -L/opt/homebrew/Cellar/libpq/16.3/lib -lpq
SRC = /Users/albertocanavese/Desktop/UniPD-database-project-2024-2.0/Codice\ C/queries.c
OUT = /Users/albertocanavese/Desktop/UniPD-database-project-2024-2.0/Codice\ C/output/queries

# Phony targets
.PHONY: all clean

# Regola di compilazione
all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) $(INCLUDES) $(SRC) -o $(OUT) $(LDFLAGS)

# Regola di pulizia
clean:
	rm -f $(OUT)
