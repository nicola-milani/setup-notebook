# setup-notebook
Questo script viene realizzato in supporto per la configurazione dei PC della scuola

Automatizza i seguenti passaggi:
- aggiornamento di sistema
- aggiunta di repository
- rimozione di software non necessario
- aggiunta manuale di alcuni software
- creazione degli utenti di default
- customizazion grafica dell'ambiente di lavoro
- aggiunta dei servizi di pulizia delle cartelle utente (ad ogni avvio)

Nella cartella "configs" sono contenuti i seguenti file:
- apt-packages-list contiene l'elenco dei pacchetti da installare tramite gestore apt
- snap-packages-list contiene l'elencod dei pacchetti da installare tramite gestore snapd
- users-list contiene l'elenco degli utenti da creare e le configurazioni per impostare l'autodelete e l'autologin
- dns-list contiene i dns da utilizzare di default (opendns)

Nella cartella "images" sono contenuti i seguenti file:
- duplica-monitor.png è l'icona da usare per la duplicazione dello schermo su proiettore
- logo_trasparent.png è il logo aziendale da utilizzare
- ply-wall.jpg e ply-wall.png sono utilizzati al boot di sistsema
- wallpaper.png è lo sfondo di default

Nella cartella "usr" sono contentue gli script installati nel sistema

Nella cartella "utils" sono contenuti alcuni script per agevolare alcune configurazioni (il cambio di sfondo di gdm e il profilo di firefox)

il file "config" definisce alcune variabili di sistema e mappa i file definiti precedentemente

per eseguire il setup rendere setpc.sh eseguibile con 
chmod +x setpc.sh
ed eseguirlo con ./setpc.sh
(Richiede privilegi di root e una connessione ad internet)