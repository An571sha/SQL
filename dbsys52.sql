SELECT * FROM dbsys51.Touristenattraktion;

SELECT ferienwohnungsName, mailadresse FROM dbsys51.Buchung;

SELECT straﬂe FROM dbsys51.Adresse WHERE landName = 'Deutschland'; 

SELECT name FROM dbsys51.FerienWohnung WHERE preisProTag < 100;

--Aufgabe2--

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
WHERE f.name NOT IN ( SELECT b.ferienwohnungsname FROM DBSYS51.buchung b )

-- Welche Ferienwohnung hat die meisten Ausstattungen? --



