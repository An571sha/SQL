
-- I guess you want to prevent from deletion of a row in the parent table in a case when there are rows in the child table that references this parent row -- 
-- if yes, then skip ON DELETE clause completely, because this is default behaviour of the foreign key constraint --
-- https://stackoverflow.com/questions/46243372/missing-keyword-in-oracle-sql --

CREATE TABLE Touristenattraktion
( 
attraktionsName varchar2(30),
CONSTRAINT pk_Touristenattraktion PRIMARY KEY (attraktionsName)
);

CREATE TABLE Land
( 
name varchar2(20),
CONSTRAINT pk_Land PRIMARY KEY (name)
);

CREATE TABLE Adresse
( 
addressId INTEGER,
postleitzahl varchar2(30), --Int zu varchar2--
straße varchar2(30),
hausnummer varchar2(3),
landName varchar2(20),
Ort varchar2(30),
CONSTRAINT pk_Adresse PRIMARY KEY (addressId),
CONSTRAINT fk_Adresse FOREIGN KEY (landName) REFERENCES Land(name)
);


CREATE TABLE Ferienwohnung
( 
name varchar2(30),
anzahlZimmer INTEGER,
größe DOUBLE PRECISION,
preisProTag DOUBLE PRECISION,
addressId INTEGER,
CONSTRAINT pk_Ferienwohnung PRIMARY KEY (name),
CONSTRAINT fk_Ferienwohnung FOREIGN KEY (addressId)
           REFERENCES Adresse(addressId)
);


CREATE TABLE EntferntVon
( 
entfernung INTEGER,
attraktionsName  varchar2(30),
ferienwohnungsName varchar2(20),
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
mailadresse  varchar2(30),
Passwort  varchar2(30),
IBAN  varchar2(30),   --eindeutig--
Kundenname  varchar2(30),
addressId INTEGER,

CONSTRAINT pk_mailadresse PRIMARY KEY (mailadresse),

CONSTRAINT fk_addressId FOREIGN KEY (addressId)
           REFERENCES Adresse(addressId)       
);


CREATE TABLE Bewertung
( 
bewertungsId INTEGER,
sterne INTEGER,
datum DATE,

CONSTRAINT pk_bewertungsId PRIMARY KEY (bewertungsId),
CONSTRAINT sterneCheck CHECK (sterne>=0 OR sterne<6)
);

--needs check--
CREATE TABLE Buchung
( 
buchungsNummer varchar2(30) NOT NULL,
datum DATE NOT NULL,
abreiseDatum DATE NOT NULL,
anreiseDatum DATE NOT NULL,
ferienwohnungsName varchar2(30) NOT NULL,
mailadresse varchar2(30) NOT NULL,
betrag INTEGER NOT NULL,
rechnungsnummer INTEGER NOT NULL,
bewertungsId INTEGER NOT NULL,
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
anzahlungsId INTEGER,
betrag DOUBLE PRECISION,
datum DATE,
buchungsNummer INTEGER,

CONSTRAINT pk_anzahlungsId PRIMARY KEY (anzahlungsId),
CONSTRAINT anzahlungsIdCheck CHECK (anzahlungsId > 0),
CONSTRAINT AnzahlungBetragCheck CHECK (betrag >= 0),   
CONSTRAINT fk_anzahlung FOREIGN KEY (buchungsNummer)
           REFERENCES Buchung(buchungsNummer)
);

CREATE TABLE Ausstattung
( 
austattungsName varchar2(30),

CONSTRAINT pk_ausstatttung PRIMARY KEY (austattungsName)
);


CREATE TABLE Besitzt
( 
austattungsName varchar2(30),
ferienwohnungsName varchar2(30),

CONSTRAINT fk_besitzt_austattungsName FOREIGN KEY (austattungsName)
           REFERENCES Ausstattung(austattungsName)
           ON DELETE CASCADE,
CONSTRAINT fk_Besitzt FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE
);

CREATE TABLE BILD
(
bildID varchar2(30),
bildinhalt BLOB,
ferienwohnungName varchar2(30),

CONSTRAINT pk_bild PRIMARY KEY (bildID),
CONSTRAINT fk_bild FOREIGN KEY (ferienwohnungName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE
);

