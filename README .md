# Bash Scripting Examples and Explanations

Questa repository raccoglie una serie di **script Bash educativi**, ognuno accompagnato da spiegazioni dettagliate sul funzionamento riga per riga.

## 📜 Contenuto degli script

### 1. `cleanup.sh`
Svuota i file di log di sistema (`messages`, `wtmp`) nella directory `/var/log`.  
⚠️ **Richiede privilegi di root.**

---

### 2. `am-i-root.sh`
Verifica se lo script è stato eseguito da root controllando l’UID o il nome utente.

---

### 3. `parameters.sh`
Mostra come gestire e stampare parametri della riga di comando, inclusa la necessità di almeno 10 parametri.

---

### 4. `naked-variables.sh`
Dimostra l’uso di variabili "nude", l'assegnazione e la lettura, con `read`, `let`, e cicli `for`.

---

### 5. `exit-status.sh`
Mostra come funzionano i codici di uscita (`$?`) in Bash, differenziando tra comandi riusciti e falliti.

---

### 6. `fetch_address.sh`
Utilizza **array associativi** in Bash 4+ per associare nomi a indirizzi e leggerli.

---

### 7. `progress-bar2.sh`
Esegue una **barra di avanzamento testuale** mentre un processo lungo è in esecuzione. Utilizza processi in background, `trap` e segnali.

---

## ⚙️ Requisiti

- GNU Bash (alcuni script richiedono Bash 4+)
- Sistema Linux/Unix-like
- Permessi di root per `cleanup.sh`

---

## ▶️ Esecuzione degli script

Assicurati che gli script abbiano permessi di esecuzione:

```bash
chmod +x scriptname.sh
