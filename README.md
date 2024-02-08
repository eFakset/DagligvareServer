### Laste ned kode til lokal maskin

1. Installere NodeJS hvis det mangler
2. /users/<user>/source/repos: git clone https://github.com/eFakset/DagligvareServer.git
3. /source/repos/DagligvareServer: npm install express
4. /source/repos/DagligvareServer: npm install mysql
5. Dagligvare/server: Rename dbconfig_mal.env til dbconfig.env.  Oppdater innhold med korrekt skjema etc.

Hvis databasen skal ligge lokalt - se lengre ned

**Start server: DagligvareServer: npm start**

### Opprette av MySQL-database:

Opprett et nytt skjema: CREATE SCHEMA `dagligvare` DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_danish_ci;

Kjør scripts i rekkefølge:

1. Drop create dagligvare MySQL.sql
2. Populering dagligvare dimensjoner.sql
3. Populering handler og bonus.sql
4. Alter table auto_increment MySQL.sql
5. SP tildele kasser.sql
6. SP beregne bonus.sql
7. Oppdater info i dbconfig.env

Legg til en ny bruker (deg selv); 
  insert into bruker (bruker_nv, passord, brukertype_kd) values('bruker', 'passord', 'A'); // Administratorer må legges til manuelt

Kjør lagret prosedyre: CALL `dagligvare`.`koble_kasse_bruker`();  // Denne må kjøres hver gang brukere har registrert seg.  Den kan kjøres gjentatte ganger, og gir en feilmelding hvis det ikke finnes kasse å tildele.
