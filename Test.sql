CREATE TABLE film
( 
FNr INTEGER NOT NULL,
Titel varchar2(30) NOT NULL,
Regie varchar2(30) NOT NULL,
Jahr varchar2(4) NOT NULL,
CONSTRAINT pk_Fnr PRIMARY KEY (FNr)
);

CREATE TABLE Schauspieler
( 
SNr INTEGER NOT NULL,
SchauspielerName varchar2(30) NOT NULL,
CONSTRAINT pk_Snr PRIMARY KEY (SNr)
);

CREATE TABLE spieltMit
( 
SNr INTEGER NOT NULL,
FNr INTEGER NOT NULL,
Gage INTEGER NOT NULL,

CONSTRAINT fk_Snr FOREIGN KEY (SNr) REFERENCES Schauspieler(SNr),
CONSTRAINT fk_Fnr FOREIGN KEY (FNr) REFERENCES film(FNr)

);

commit;

INSERT INTO film VALUES (12,'Casino Royale','Martin Campbell',2006);
INSERT INTO film VALUES (13,'Mass','George Campbell',2004);
INSERT INTO film VALUES (15,'Juhno','Ross Pott',1996);
INSERT INTO film VALUES (14,'Das Parfum','Tom Tykwer',2006);
INSERT INTO Schauspieler VALUES (26,'Dustin Hoffman');
INSERT INTO Schauspieler VALUES (28,'Daniel Craig');
INSERT INTO Schauspieler VALUES (29,'Bradd Pitt');
INSERT INTO spieltMit VALUES (26,12,40000);
INSERT INTO spieltMit VALUES (28,13,80000);
INSERT INTO spieltMit VALUES (28,14,80000);


---/// Anfragen ///--

SELECT s.SchauspielerName , count(m.FNr)
FROM schauspieler s, spieltmit m
WHERE s.SchauspielerName = 'Dustin Hoffman' AND s.SNr = m.SNr
GROUP by s.SchauspielerName;

SELECT m.Gage , f.Titel
FROM film f, spieltmit m 
WHERE f.fnr = m.fnr AND f.Titel = 'Mass'
GROUP BY m.Gage, f.Titel;




