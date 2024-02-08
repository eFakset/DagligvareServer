use dagligvare;

DROP TABLE IF EXISTS bonus;
DROP TABLE IF EXISTS varelinje;
DROP TABLE IF EXISTS handel;
DROP TABLE IF EXISTS kjedevaregruppebonus;
DROP TABLE IF EXISTS kjedebonus;
DROP TABLE IF EXISTS kjedevarepris;
DROP TABLE IF EXISTS vare;
DROP TABLE IF EXISTS varegruppe;
DROP TABLE IF EXISTS mengdeenhet;
DROP TABLE IF EXISTS bruker;
DROP TABLE IF EXISTS brukertype;
DROP TABLE IF EXISTS kasse;
DROP TABLE IF EXISTS butikk;
DROP TABLE IF EXISTS kjede;
DROP TABLE IF EXISTS kunde;
DROP TABLE IF EXISTS kommune;
DROP TABLE IF EXISTS fylke;

/****  Oppretter tabeller  *****/


/****** Object:  Table fylke] ******/

CREATE TABLE fylke (
  fylke_nr SMALLINT NOT NULL DEFAULT 0,
  fylke_nv varchar(255) NOT NULL,
  PRIMARY KEY (fylke_nr)
);

/****** Object:  Table kommune] ******/
CREATE TABLE kommune(
	kommune_nr SMALLINT NOT NULL DEFAULT 0,
	kommune_nv varchar(255) NOT NULL,
	fylke_nr smallint NOT NULL,
PRIMARY KEY (kommune_nr)
);

ALTER TABLE kommune
 ADD CONSTRAINT FK_kommune_fylke FOREIGN KEY FK_kommune_fylke (fylke_nr)
    REFERENCES fylke (fylke_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kunde ******/
CREATE TABLE kunde (
	kunde_nr SMALLINT NOT NULL DEFAULT 0,
	kunde_nv varchar(255) NOT NULL,
	kommune_nr SMALLINT NOT NULL DEFAULT 0,
 PRIMARY KEY (kunde_nr)
);

ALTER TABLE kunde
 ADD CONSTRAINT FK_kunde_kommune FOREIGN KEY FK_kunde_kommune (kommune_nr)
    REFERENCES kommune (kommune_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kjede ******/
CREATE TABLE kjede (
	kjede_nr SMALLINT NOT NULL DEFAULT 0,
	kjede_nv varchar(255) NOT NULL,
 PRIMARY KEY (kjede_nr)
);

/****** Object:  Table butikk ******/
CREATE TABLE butikk(
	butikk_nr SMALLINT NOT NULL DEFAULT 0,
	butikk_nv varchar(255) NOT NULL,
	kjede_nr SMALLINT NOT NULL DEFAULT 0,
	kommune_nr SMALLINT NOT NULL DEFAULT 0,
 PRIMARY KEY (butikk_nr)
);

ALTER TABLE butikk
 ADD CONSTRAINT FK_butikk_kjede FOREIGN KEY FK_butikk_kjede (kjede_nr)
    REFERENCES kjede (kjede_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE butikk
 ADD CONSTRAINT FK_butikk_kommune FOREIGN KEY FK_butikk_kommune (kommune_nr)
    REFERENCES kommune (kommune_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kasse ******/

CREATE TABLE `kasse` (
  `butikk_nr` smallint NOT NULL DEFAULT '0',
  `kasse_nr` smallint NOT NULL DEFAULT '0',
  `bruker_nr` smallint NOT NULL DEFAULT '-1',
  PRIMARY KEY (`butikk_nr`,`kasse_nr`)
);

ALTER TABLE kasse
 ADD CONSTRAINT FK_kasse_butikk FOREIGN KEY FK_kasse_butikk (butikk_nr)
    REFERENCES butikk (butikk_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;
    
/****** Object:  Table brukertype ******/
    
CREATE TABLE brukertype (
  brukertype_kd char(2) NOT NULL,
  brukertype_nv varchar(45) NOT NULL,
  PRIMARY KEY (brukertype_kd)
);

/****** Object:  Table bruker ******/

CREATE TABLE bruker (
  bruker_nr int NOT NULL auto_increment,
  bruker_nv varchar(45) NOT NULL,
  passord varchar(45) NOT NULL,
  brukertype_kd char(1) NOT NULL,
  PRIMARY KEY (bruker_nr)
);

ALTER TABLE bruker
 ADD CONSTRAINT FK_bruker_brukertype FOREIGN KEY FK_bruker_brukertype (brukertype_kd)
    REFERENCES brukertype (brukertype_kd)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table varegruppe ******/
CREATE TABLE varegruppe (
	varegruppe_nr SMALLINT NOT NULL DEFAULT 0,
	varegruppe_nv varchar(255) NOT NULL,
	mvasats_pct tinyint NULL,
 PRIMARY KEY (varegruppe_nr)
);

/****** Object:  Table mengdeenhet  ******/
CREATE TABLE mengdeenhet (
	mengdeenhet_nr TINYINT NOT NULL,
	mengdeenhet_nv varchar(45) NOT NULL,
 PRIMARY KEY (mengdeenhet_nr)
);

/****** Object:  Table vare  ******/
CREATE TABLE vare (
	vare_nr SMALLINT NOT NULL DEFAULT 0,
	vare_nv varchar(255) NOT NULL,
	varegruppe_nr SMALLINT NOT NULL DEFAULT 0,
    mengdeenhet_nr TINYINT NOT NULL DEFAULT 0,
 PRIMARY KEY (vare_nr)
);

ALTER TABLE vare
 ADD CONSTRAINT FK_vare_varegruppe FOREIGN KEY FK_vare_varegruppe (varegruppe_nr)
    REFERENCES varegruppe (varegruppe_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;


ALTER TABLE vare
 ADD CONSTRAINT FK_vare_mengdeenhet FOREIGN KEY FK_vare_mengdeenhet (mengdeenhet_nr)
    REFERENCES mengdeenhet (mengdeenhet_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kjedevarepris ******/
CREATE TABLE kjedevarepris (
	kjede_nr SMALLINT NOT NULL DEFAULT 0,
	vare_nr SMALLINT NOT NULL DEFAULT 0,
	gjelder_fra datetime NOT NULL,
	gjelder_til datetime NULL,
	enhetpris_bel decimal(7, 2) NOT NULL,
 PRIMARY KEY (kjede_nr, vare_nr, gjelder_fra)
);

ALTER TABLE kjedevarepris
 ADD CONSTRAINT FK_kjedevarepris_kjede FOREIGN KEY FK_kjedevarepris_kjede (kjede_nr)
    REFERENCES kjede (kjede_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE kjedevarepris
 ADD CONSTRAINT FK_kjedevarepris_vare FOREIGN KEY FK_kjedevarepris_vare (vare_nr)
    REFERENCES vare (vare_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kjedebonus ******/
CREATE TABLE kjedebonus (
	kjede_nr SMALLINT NOT NULL DEFAULT 0,
	gjelder_fra datetime NOT NULL,
	gjelder_til datetime NULL,
	bonussats_pct smallint NOT NULL,
 PRIMARY KEY (kjede_nr, gjelder_fra)
);

ALTER TABLE kjedebonus
 ADD CONSTRAINT FK_kjedebonus_kjede FOREIGN KEY FK_kjedebonus_kjede (kjede_nr)
    REFERENCES kjede (kjede_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table kjedevaregruppebonus ******/
CREATE TABLE kjedevaregruppebonus (
	kjede_nr SMALLINT NOT NULL DEFAULT 0,
	varegruppe_nr SMALLINT NOT NULL DEFAULT 0,
	gjelder_fra datetime NOT NULL,
	gjelder_til datetime NULL,
	bonussats_pct smallint NOT NULL,
 PRIMARY KEY (kjede_nr, varegruppe_nr, gjelder_fra)
);

ALTER TABLE kjedevaregruppebonus
 ADD CONSTRAINT FK_kjedevaregruppebonus_kjede FOREIGN KEY FK_kjedevaregruppebonus_kjede (kjede_nr)
    REFERENCES kjede (kjede_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE kjedevaregruppebonus
 ADD CONSTRAINT FK_kjedevaregruppebonus_varegruppe FOREIGN KEY FK_kjedevaregruppebonus_varegruppe (varegruppe_nr)
    REFERENCES varegruppe (varegruppe_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table handel ******/
CREATE TABLE handel (
	handel_nr int NOT NULL,
	tidspunkt datetime NOT NULL,
	butikk_nr SMALLINT NOT NULL DEFAULT 0,
	kasse_nr SMALLINT NOT NULL DEFAULT 0,
	kunde_nr SMALLINT NOT NULL DEFAULT 0,
	handel_bel decimal(9, 2) NOT NULL,
 PRIMARY KEY (handel_nr)
);

ALTER TABLE handel
 ADD CONSTRAINT FK_handel_kasse FOREIGN KEY FK_handel_kasse (butikk_nr, kasse_nr)
    REFERENCES kasse (butikk_nr, kasse_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE handel
 ADD CONSTRAINT FK_handel_kunde FOREIGN KEY FK_handel_kunde (kunde_nr)
    REFERENCES kunde (kunde_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table varelinje ******/

CREATE TABLE varelinje (
	handel_nr int NOT NULL,
	varelinje_nr SMALLINT NOT NULL DEFAULT 0,
	vare_nr SMALLINT NOT NULL DEFAULT 0,
	enhet_ant decimal(7, 3) NOT NULL,
	enhetpris_bel decimal(7, 2) NOT NULL,
	varelinje_bel decimal(9, 2) NOT NULL,
 PRIMARY KEY (handel_nr, varelinje_nr)
);

ALTER TABLE varelinje
 ADD CONSTRAINT FK_varelinje_vare FOREIGN KEY FK_varelinje_vare (vare_nr)
    REFERENCES vare (vare_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

/****** Object:  Table bonus ******/
CREATE TABLE bonus (
	handel_nr int NOT NULL,
	varegruppe_nr SMALLINT NOT NULL DEFAULT 0,
	bonus_bel decimal(5, 2) NOT NULL,
 PRIMARY KEY (handel_nr, varegruppe_nr)
);

ALTER TABLE bonus
 ADD CONSTRAINT FK_bonus_varegruppe FOREIGN KEY FK_bonus_varegruppe (varegruppe_nr)
    REFERENCES varegruppe (varegruppe_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;
