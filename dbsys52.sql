SELECT * FROM dbsys51.Touristenattraktion;

SELECT ferienwohnungsName, mailadresse FROM dbsys51.Buchung;

SELECT straﬂe FROM dbsys51.Adresse WHERE landName = 'Deutschland'; 

SELECT name FROM dbsys51.FerienWohnung WHERE preisProTag < 100;

--Teil4--

--Wie viele Ferienwohnungen sind pro Stadtnamen gespeichert? --

SELECT ort, count (name)
FROM DBSYS51.ferienwohnung f, DBSYS51.adresse a
Where f.addressId = a.addressId
GROUP BY ort,name;

--Welche Ferienwohnungen in Spanien haben durchschnittlich mehr als 4 Sterne erhalten? --

SELECT name,ort,landname,sterne
FROM DBSYS51.ferienwohnung f, DBSYS51.adresse a, DBSYS51.bewertung b,DBSYS51.buchung be
WHERE f.addressId = a.addressId AND a.landname = 'Spanien' AND be.ferienwohnungsname = f.name
GROUP BY name,ort,landname,sterne
HAVING sterne > 4;

--Wie viele Ferienwohnungen wurden noch nie gebucht? --

SELECT name
FROM DBSYS51.ferienwohnung f
WHERE f.name NOT IN ( SELECT b.ferienwohnungsname FROM DBSYS51.buchung b );

-- Welche Ferienwohnung hat die meisten Ausstattungen? ERROR? WHY? --
SELECT f.name, MAX(count(b.austattungsname))
FROM DBSYS51.ferienwohnung f, DBSYS51.besitzt b
WHERE f.name = b.ferienwohnungsname
GROUP BY f.name, b.austattungsname;

-- Wie viele Reservierungen gibt es f¸r die einzelnen L‰nder? L‰nder, in denen keine Reservierungen existieren, sollen mit der Anzahl 0 ebenfalls aufgef¸hrt werden. Das Ergebnis soll nach der Anzahl Reservierungen absteigend sortiert werden.--

-- needs correction --
SELECT a.landname, count( b.ferienwohnungsname)
FROM DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.ferienwohnung f
WHERE b.ferienwohnungsname(+) = f.name AND f.addressId = a.addressId
GROUP BY a.landname, b.ferienwohnungsname
ORDER BY count(b.ferienwohnungsname) DESC;

--Welche Ferienwohnungen mit Sauna sind in Spanien in der Zeit vom 1.11.2019 ñ 21.11.2019 noch frei?Geben Sie den Ferienwohnungs-Namen und deren durchschnittliche Bewertung an. Ferienwohnungenmit guten Bewertungen sollen zuerst angezeigt werden --

SELECT f.name
FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a
WHERE
    b.ferienwohnungsname = f.name AND
    NOT EXISTS( 
    SELECT be.ferienwohnungsname
    FROM DBSYS51.buchung be WHERE be.abreisedatum > to_date('21.11.2019', 'DD.MM.YYYY') 
    AND be.anreisedatum > to_date('1.11.2019', 'DD.MM.YYYY'))
    AND f.addressId = a.addressId 
    AND a.landname = 'Spanien'
    AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = 'Sauna');
   


