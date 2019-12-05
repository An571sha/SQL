
-- I guess you want to prevent from deletion of a row in the parent table in a case when there are rows in the child table that references this parent row -- 
-- if yes, then skip ON DELETE clause completely, because this is default behaviour of the foreign key constraint --
-- https://stackoverflow.com/questions/46243372/missing-keyword-in-oracle-sql --

CREATE TABLE Touristenattraktion
( 
attraktionsName varchar2(30) NOT NULL,
CONSTRAINT pk_Touristenattraktion PRIMARY KEY (attraktionsName)
);

CREATE TABLE Land
( 
name varchar2(20) NOT NULL,
CONSTRAINT pk_Land PRIMARY KEY (name)
);

CREATE TABLE Adresse
( 
addressId INTEGER NOT NULL,
postleitzahl varchar2(30) NOT NULL, --Int zu varchar2--
straße varchar2(30) NOT NULL,
hausnummer varchar2(3) NOT NULL,
landName varchar2(20) NOT NULL,
Ort varchar2(30) NOT NULL,
CONSTRAINT pk_Adresse PRIMARY KEY (addressId),
CONSTRAINT fk_Adresse FOREIGN KEY (landName) REFERENCES Land(name)
);


CREATE TABLE Ferienwohnung
( 
name varchar2(30) NOT NULL,
anzahlZimmer INTEGER NOT NULL,
größe DOUBLE PRECISION NOT NULL,
preisProTag DOUBLE PRECISION NOT NULL,
addressId INTEGER NOT NULL,
CONSTRAINT pk_Ferienwohnung PRIMARY KEY (name),
CONSTRAINT fk_Ferienwohnung FOREIGN KEY (addressId)
           REFERENCES Adresse(addressId)
);


CREATE TABLE EntferntVon
( 
entfernung INTEGER NOT NULL,
attraktionsName  varchar2(30) NOT NULL,
ferienwohnungsName varchar2(20) NOT NULL,

CONSTRAINT pk_EntferntVon PRIMARY KEY (attraktionsName,ferienwohnungsName),

CONSTRAINT fk_attraktionsName FOREIGN KEY (attraktionsName)
           REFERENCES Touristenattraktion(attraktionsName)
           ON DELETE CASCADE,
CONSTRAINT fk_ferienwohnungsName FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE,
CONSTRAINT entfernungCheck CHECK (entfernung > 0)           
);


CREATE TABLE Kunde
( 
mailadresse  varchar2(30) NOT NULL,
Passwort  varchar2(30) NOT NULL,
IBAN  varchar2(30) NOT NULL,   --eindeutig--
Kundenname  varchar2(30) NOT NULL,
addressId INTEGER NOT NULL,

CONSTRAINT pk_mailadresse PRIMARY KEY (mailadresse),

CONSTRAINT fk_addressId FOREIGN KEY (addressId)
           REFERENCES Adresse(addressId)       
);


CREATE TABLE Bewertung
( 
bewertungsId INTEGER NOT NULL,
sterne INTEGER NOT NULL,
datum DATE NOT NULL,

CONSTRAINT pk_bewertungsId PRIMARY KEY (bewertungsId),
CONSTRAINT sterneCheck CHECK (sterne>=0 OR sterne<6)
);

--needs check--
CREATE TABLE Buchung
( 
buchungsNummer INTEGER NOT NULL,
datum DATE NOT NULL,
abreiseDatum DATE NOT NULL,
anreiseDatum DATE NOT NULL,
ferienwohnungsName varchar2(30) NOT NULL,
mailadresse varchar2(30) NOT NULL,
betrag INTEGER NOT NULL,
rechnungsnummer INTEGER NOT NULL,
bewertungsId INTEGER,
rechnungsdatum DATE NOT NULL,

CONSTRAINT pk_Buchung PRIMARY KEY (buchungsNummer),

CONSTRAINT fk_Buchungs_ferienwohnungsName FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name),

CONSTRAINT fk_mailadresse FOREIGN KEY (mailadresse)
           REFERENCES Kunde(mailadresse),

CONSTRAINT fk_Buchung_bewertungsId FOREIGN KEY (bewertungsId)
           REFERENCES Bewertung(bewertungsId),           

CONSTRAINT BetragCheck CHECK (betrag > 0),

CONSTRAINT RechnungsNrCheck CHECK (rechnungsnummer > 0)
);

CREATE TABLE Anzahlung
( 
anzahlungsId INTEGER NOT NULL,
betrag DOUBLE PRECISION NOT NULL,
datum DATE NOT NULL,
buchungsNummer INTEGER NOT NULL,

CONSTRAINT pk_anzahlungsId PRIMARY KEY (anzahlungsId),
CONSTRAINT anzahlungsIdCheck CHECK (anzahlungsId > 0),
CONSTRAINT AnzahlungBetragCheck CHECK (betrag >= 0),   
CONSTRAINT fk_anzahlung FOREIGN KEY (buchungsNummer)
           REFERENCES Buchung(buchungsNummer)
);

CREATE TABLE Ausstattung
( 
austattungsName varchar2(30) NOT NULL,

CONSTRAINT pk_ausstatttung PRIMARY KEY (austattungsName)
);


CREATE TABLE Besitzt
( 
austattungsName varchar2(30) NOT NULL,
ferienwohnungsName varchar2(30) NOT NULL,

CONSTRAINT fk_besitzt_austattungsName FOREIGN KEY (austattungsName)
           REFERENCES Ausstattung(austattungsName)
           ON DELETE CASCADE,
CONSTRAINT fk_Besitzt FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE
);

CREATE TABLE BILD
(
bildID varchar2(30) NOT NULL,
bildinhalt BLOB NOT NULL,
ferienwohnungName varchar2(30) NOT NULL,

CONSTRAINT pk_bild PRIMARY KEY (bildID),
CONSTRAINT fk_bild FOREIGN KEY (ferienwohnungName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE
);

INSERT INTO Land VALUES ('Deutschland');
INSERT INTO Land VALUES ('Frankreich');
INSERT INTO Land VALUES ('Schweiz');
INSERT INTO Land VALUES ('Spanien');
INSERT INTO Land VALUES ('Portugal');

INSERT INTO Adresse VALUES (1,78462,'gutstraße','12','Deutschland','Konstanz');
INSERT INTO Adresse VALUES (2,32000,'rue Sadi Carnot','58','Frankreich','Bordeaux');
INSERT INTO Adresse VALUES (3,75016,'rue La Boetie','126','Frankreich','Paris');
INSERT INTO Adresse VALUES (4,75004,'rue Nationale','103','Frankreich','Paris');
INSERT INTO Adresse VALUES (5,69004,'rue de la République','50','Frankreich','Lyon');
INSERT INTO Adresse VALUES (6,4190,'Untere Bahnhofstrasse','107','Schweiz','Cama');
INSERT INTO Adresse VALUES (7,4089,'Breitenstrasse','51','Schweiz','Basel');
INSERT INTO Adresse VALUES (8,8001,'Strickstrasse','115','Schweiz','Zürich');
INSERT INTO Adresse VALUES (9,9029,'Via Pestariso','12A','Schweiz','St.Gallen');
INSERT INTO Adresse VALUES (10,16271,'Landhausstraße','94','Deutschland','Angermünde');
INSERT INTO Adresse VALUES (11,54675,'Güntzelstrasse','90','Deutschland','Rheinland-Pfalz');
INSERT INTO Adresse VALUES (12,41450,'Eusebio Dávila','10','Spanien','Constantina');
INSERT INTO Adresse VALUES (13,39846,'Extramuros','1A','Spanien','Madrid');
INSERT INTO Adresse VALUES (14,08940,'Comandante','67','Spanien','Barcelona');
INSERT INTO Adresse VALUES (15,46210,'Picanya','98','Spanien','Valencia');
INSERT INTO Adresse VALUES (16,384022,'Cortinhas Fonte','57','Portugal','Setubal');
INSERT INTO Adresse VALUES (17,2890-308,'Familia Marques','98','Portugal','Madeira');
INSERT INTO Adresse VALUES (18,22210,'Alferes Pestana','68','Portugal','Quebrada');
INSERT INTO Adresse VALUES (19,34210,'Veiga','1','Portugal','Ilha');

INSERT INTO Ferienwohnung VALUES('Sky Hotel',5,30.00,50.00,1);
INSERT INTO Ferienwohnung VALUES('Tiara One',10,60.70,70.00,2);
INSERT INTO Ferienwohnung VALUES('Negresco',12,88.32,90.00,3);
INSERT INTO Ferienwohnung VALUES('Ritz',20,120.32,200.00,7);
INSERT INTO Ferienwohnung VALUES('Armani',32,132.22,220.00,9);
INSERT INTO Ferienwohnung VALUES('ibis',50,82.22,120.00,11);
INSERT INTO Ferienwohnung VALUES('Santo Domingo',22,68.88,99.60,13);
INSERT INTO Ferienwohnung VALUES('Zmar',32,79.80,150.00,15);

INSERT INTO Buchung VALUES(1,to_date('01.02.2018', 'DD.MM.YYYY'),to_date('01.09.2018', 'DD.MM.YYYY'),to_date('03.09.2018', 'DD.MM.YYYY'),'Sky Hotel','anim@webdesign.de',150,100,1,to_date('01.02.2018', 'DD.MM.YYYY'));
INSERT INTO Buchung VALUES(2,to_date('05.03.2018', 'DD.MM.YYYY'),to_date('08.09.2018', 'DD.MM.YYYY'),to_date('09.09.2018', 'DD.MM.YYYY'),'Tiara One','anim@webdesign.de',70,101,2,to_date('01.07.2018', 'DD.MM.YYYY'));
INSERT INTO Buchung VALUES(3,to_date('20.01.2018', 'DD.MM.YYYY'),to_date('01.06.2018', 'DD.MM.YYYY'),to_date('04.06.2018', 'DD.MM.YYYY'),'Negresco','jan@webdesign.de',270,102,3,to_date('20.01.2018', 'DD.MM.YYYY'));
INSERT INTO Buchung VALUES(4,to_date('15.02.2018', 'DD.MM.YYYY'),to_date('20.07.2018', 'DD.MM.YYYY'),to_date('22.07.2018', 'DD.MM.YYYY'),'Ritz','jan@webdesign.de',400,103,4,to_date('15.02.2018', 'DD.MM.YYYY'));
INSERT INTO Buchung VALUES(5,to_date('19.03.2018', 'DD.MM.YYYY'),to_date('01.04.2018', 'DD.MM.YYYY'),to_date('03.04.2018', 'DD.MM.YYYY'),'Armani','janko@webdesign.de',660,104,5,to_date('19.03.2018', 'DD.MM.YYYY'));
INSERT INTO Buchung VALUES(6,to_date('20.10.2018', 'DD.MM.YYYY'),to_date('31.12.2019', 'DD.MM.YYYY'),to_date('02.01.2019', 'DD.MM.YYYY'),'Santo Domingo','anim@webdesign.de',199.2,105,6,to_date('20.10.2018', 'DD.MM.YYYY'));

INSERT INTO Kunde VALUES('anim@webdesign.de','012345678','AB222222','Animesh',19);
INSERT INTO Kunde VALUES('jan@webdesign.de','2121214','CD333333','Jan',18);
INSERT INTO Kunde VALUES('janko@webdesign.de','3131314','EF44444','Janko',17);

INSERT INTO Touristenattraktion VALUES('Altstadt');
INSERT INTO Touristenattraktion VALUES('Port');
INSERT INTO Touristenattraktion VALUES('Eifel Tower');
INSERT INTO Touristenattraktion VALUES('Old Church');

INSERT INTO EntferntVon VALUES(10,'Altstadt','Sky Hotel');
INSERT INTO EntferntVon VALUES(13,'Port','Tiara One');
INSERT INTO EntferntVon VALUES(22,'Eifel Tower','Negresco');
INSERT INTO EntferntVon VALUES(05,'Old Church','Ritz');

INSERT INTO Ausstattung VALUES('Sauna');
INSERT INTO Ausstattung VALUES('Pool');
INSERT INTO Ausstattung VALUES('Minbar');
INSERT INTO Ausstattung VALUES('TV');
INSERT INTO Ausstattung VALUES('WLAN');


INSERT INTO Besitzt VALUES('Sauna','Negresco');
INSERT INTO Besitzt VALUES('Sauna','Ritz');
INSERT INTO Besitzt VALUES('Pool','Sky Hotel');
INSERT INTO Besitzt VALUES('Pool','Tiara One');
INSERT INTO Besitzt VALUES('Pool','Ritz');
INSERT INTO Besitzt VALUES('Minbar','Sky Hotel');
INSERT INTO Besitzt VALUES('Minbar','Tiara One');
INSERT INTO Besitzt VALUES('Minbar','Negresco');
INSERT INTO Besitzt VALUES('TV','Ritz');
INSERT INTO Besitzt VALUES('TV','Negresco');
INSERT INTO Besitzt VALUES('TV','Sky Hotel');
INSERT INTO Besitzt VALUES('WLAN','Ritz');
INSERT INTO Besitzt VALUES('Sauna','Armani');
INSERT INTO Besitzt VALUES('Pool','Armani');
INSERT INTO Besitzt VALUES('WLAN','Armani');

INSERT INTO Anzahlung VALUES(200,150,to_date('01.02.2018', 'DD.MM.YYYY'),1);
INSERT INTO Anzahlung VALUES(201,70,to_date('01.07.2018', 'DD.MM.YYYY'),2);
INSERT INTO Anzahlung VALUES(202,270,to_date('20.01.2018', 'DD.MM.YYYY'),3);
INSERT INTO Anzahlung VALUES(203,400,to_date('15.02.2018', 'DD.MM.YYYY'),4);
INSERT INTO Anzahlung VALUES(204,660,to_date('19.03.2018', 'DD.MM.YYYY'),5);
INSERT INTO Anzahlung VALUES(205,199.2,to_date('20.10.2018', 'DD.MM.YYYY'),6);

INSERT INTO Bewertung VALUES(1,4,to_date('03.09.2018'));
INSERT INTO Bewertung VALUES(2,3,to_date('10.09.2018'));
INSERT INTO Bewertung VALUES(3,5,to_date('05.06.2018'));
INSERT INTO Bewertung VALUES(4,4,to_date('24.07.2018'));
INSERT INTO Bewertung VALUES(5,5,to_date('03.04.2018'));
INSERT INTO Bewertung VALUES(6,5,to_date('03.01.2019'));

GRANT SELECT ON Land TO dbsys52;
GRANT SELECT ON Besitzt TO dbsys52;
GRANT SELECT ON Ausstattung TO dbsys52;
GRANT SELECT ON EntferntVon TO dbsys52;
GRANT SELECT ON Touristenattraktion TO dbsys52;

GRANT SELECT ON Kunde TO dbsys52;
GRANT INSERT ON Kunde TO dbsys52;
GRANT DELETE ON Kunde TO dbsys52;
GRANT UPDATE ON Kunde TO dbsys52;

GRANT SELECT ON Buchung TO dbsys52;
GRANT INSERT ON Buchung TO dbsys52;

GRANT SELECT ON Ferienwohnung TO dbsys52;

GRANT SELECT ON Adresse TO dbsys52;
GRANT INSERT ON Adresse TO dbsys52;
GRANT DELETE ON Adresse TO dbsys52;

GRANT SELECT ON Bewertung TO dbsys52;
GRANT INSERT ON Bewertung TO dbsys52;
GRANT DELETE ON Bewertung TO dbsys52;

GRANT SELECT ON Bild TO dbsys52;



