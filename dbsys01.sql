
-- I guess you want to prevent from deletion of a row in the parent table in a case when there are rows in the child table that references this parent row -- 
-- if yes, then skip ON DELETE clause completely, because this is default behaviour of the foreign key constraint --
-- https://stackoverflow.com/questions/46243372/missing-keyword-in-oracle-sql --

CREATE TABLE Touristenattraktion
( 
attraktionsName varchar(30),
CONSTRAINT pk_Touristenattraktion PRIMARY KEY (attraktionsName)
);

CREATE TABLE Land
( 
name varchar(20),
CONSTRAINT pk_Land PRIMARY KEY (name)
);

CREATE TABLE Adresse
( 
addressId INTEGER,
postleitzahl INTEGER,
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
attraktionsName  varchar(30),
ferienwohnungsName varchar(20),
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
mailadresse  varchar(30),
Passwort  varchar(30),
IBAN  varchar(30),   --eindeutig--
Kundenname  varchar(30),
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
buchungsNummer varchar(30),
datum DATE,
abreiseDatum DATE,
anreiseDatum DATE,
ferienwohnungsName varchar(30),
mailadresse varchar(30),
betrag INTEGER,
rechnungsnummer INTEGER,
bewertungsId INTEGER,

CONSTRAINT pk_Buchung PRIMARY KEY (buchungsNummer),

CONSTRAINT fk_Buchungs_ferienwohnungsName FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name),
CONSTRAINT fk_mailadresse FOREIGN KEY (mailadresse)
           REFERENCES Kunde(mailadresse),
CONSTRAINT fk_Buchung_bewertungsId FOREIGN KEY (bewertungsId)
           REFERENCES Bewertung(bewertungsId),           
CONSTRAINT BetragCheck CHECK (betrag > 0)           
);

CREATE TABLE Anzahlung
( 
anzahlungsId INTEGER,
betrag DOUBLE PRECISION,
datum DATE,
buchungsNummer varchar(30),

CONSTRAINT pk_anzahlungsId PRIMARY KEY (anzahlungsId),
CONSTRAINT anzahlungsIdCheck CHECK (anzahlungsId > 0),
CONSTRAINT AnzahlungBetragCheck CHECK (betrag >= 0),   
CONSTRAINT fk_anzahlung FOREIGN KEY (buchungsNummer)
           REFERENCES Buchung(buchungsNummer)
);

CREATE TABLE Ausstattung
( 
austattungsName varchar(30),

CONSTRAINT pk_ausstatttung PRIMARY KEY (austattungsName)
);


CREATE TABLE Besitzt
( 
austattungsName varchar(30),
ferienwohnungsName varchar(30),

CONSTRAINT fk_besitzt_austattungsName FOREIGN KEY (austattungsName)
           REFERENCES Ausstattung(austattungsName),
CONSTRAINT fk_Besitzt FOREIGN KEY (ferienwohnungsName)
           REFERENCES Ferienwohnung(name)           
);







