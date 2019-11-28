CREATE TABLE Touristenattraktion
( 
attraktionsName varchar(30),
CONSTRAINT pk_Ferienwohnung PRIMARY KEY (attraktionsName)
);

CREATE TABLE Land
( 
name varchar(20),
CONSTRAINT pk_Land PRIMARY KEY (name)
);


CREATE TABLE Ferienwohnung
( 
name varchar(30),
anzahlZimmer INTEGER,
größe DOUBLE,
preisProTag DOUBLE,
addressId INTEGER,
CONSTRAINT pk_Ferienwohnung PRIMARY KEY (name),
CONSTRAINT fk_Ferienwohnung FOREIGN KEY (addressId)
           REFERENCES Adresse(addressId)
           ON DELETE RESTRICT
);


CREATE TABLE EntferntVon
( 
entfernung INTEGER,
attraktionsName  varchar(30),
FerienwohnungsName varchar(20),
CONSTRAINT fk_EntferntVon FOREIGN KEY (attraktionsName)
           REFERENCES Touristenattraktion(attraktionsName)
           ON DELETE CASCADE,
CONSTRAINT fk_FerienwohnungsName FOREIGN KEY (FerienwohnungsName)
           REFERENCES Ferienwohnung(name)
           ON DELETE CASCADE,
CONSTRAINT entfernungCheck CHECK (entfernung > 0)           
);




