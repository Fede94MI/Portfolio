-----MOSTRARE I RESPONSABILI CON I LORO PARCHI ----

SELECT r.IDResponsabile, p.Nome_Parco
FROM RESPONSABILE AS r
INNER JOIN PARCO AS p
ON r.IDResponsabile=p.IDResponsabile
GROUP BY r.IDResponsabile, p.Nome_Parco


----MOSTRARE I PARCHI DI OGNI REGIONE e SUDDIVISI PER AREA GEOGRAFICA
SELECT r.Nome_Regione, p.Nome_Parco, pos.IDPosizione
FROM PARCO AS p
INNER JOIN REGIONE AS r
ON p.IDRegione=r.IDRegione
INNER JOIN POSIZIONE AS pos
ON p.IDPosizione=pos.IDPosizione
GROUP BY r.Nome_Regione,p.Nome_Parco, pos.IDPosizione
ORDER BY pos.IDPosizione ASC

--------1°MOSTRARE I GUARDIACACCIA DI SESSO FEMMINILE E CHE HANNO IN GESTIONE UN PARCO----CON QUERY RICORSIVA
SELECT resp.Nome, resp.Cognome, par.Nome_Parco
FROM RESPONSABILE AS resp
INNER JOIN PARCO AS par
ON resp.IDResponsabile=par.IDResponsabile
WHERE resp.Sesso= (
									SELECT Sesso
									FROM RESPONSABILE
									WHERE Sesso='F'
									GROUP BY Sesso
									)
GROUP BY resp.Nome, resp.Cognome, par.Nome_Parco

------2°versione con utilizzo di HAVING

SELECT resp.Nome, resp.Cognome, par.Nome_Parco, resp.Sesso
FROM RESPONSABILE AS resp
INNER JOIN PARCO AS par
ON resp.IDResponsabile=par.IDResponsabile
GROUP BY resp.Nome, resp.Cognome, par.Nome_Parco, resp.Sesso
HAVING resp.Sesso='F'
---------------------------------------------------------------------------------

----MOSTRARE SOLO I GUARDIACACCIA UOMINI CHE HANNO UN PARCO IN GESTIONE E CHE SONO STATI ASSUNTI DOPO IL 01.01.2000 E DA QUANTI ANNI LAVORANO RISPETTO ALLA DATA DI
----ESECUZIONE DELLA QUERY

SELECT resp.Nome, resp.Cognome, par.Nome_Parco, resp.Sesso, resp.DataAssunzione ,DATEDIFF(yy,resp.DataAssunzione,GETDATE()) AS AnniLavorati
FROM RESPONSABILE AS resp
INNER JOIN PARCO AS par
ON resp.IDResponsabile=par.IDResponsabile
WHERE resp.Sesso= (
									SELECT Sesso
									FROM RESPONSABILE
									WHERE Sesso='M'
									GROUP BY Sesso
									)
GROUP BY resp.Nome, resp.Cognome, par.Nome_Parco, resp.Sesso, resp.DataAssunzione
HAVING resp.DataAssunzione  >'2000.01.01'

--MOSTRARE TUTTI GUARDIACACCIA CHE SONO NATI IN UN DETERMINATO MESE, CHE HANNO UN PARCO IN GESTIONE IN UNA AREA GEOGRAFICA
--E MOSTRARE DA QUANTI ANNI LAVORANO
--UTILIZZO RIGHT JOIN SOLO PER "STILE"

SELECT resp.IDResponsabile,par.IDPosizione, resp.Nome, resp.Cognome,resp.Data_Nascita, DATENAME(MONTH,resp.Data_Nascita) AS Mese_Nascita
	, DATEDIFF(yy,resp.DataAssunzione,GETDATE()) AS AnniLavorati
FROM RESPONSABILE AS resp
RIGHT JOIN PARCO AS par
ON resp.IDResponsabile=par.IDResponsabile
WHERE resp.IDResponsabile is not null AND MONTH(resp.Data_Nascita)=10
GROUP BY resp.IDResponsabile, resp.Nome, resp.Cognome, DATENAME(MONTH,resp.Data_Nascita), par.IDPosizione, resp.Data_Nascita, DATEDIFF(yy,resp.DataAssunzione,GETDATE())
HAVING par.IDPosizione='NORD'

--MOSTRARE GLI ANIMALI CHE APPARTENGONO AD UN PARCO con un certo grado di "estinzione", con popolazione totale--

SELECT sp.NomeSpecieAnimale,sp.IDSpecieAnimale,par.IDParco,par.Nome_Parco, COUNT(sp.IDSpecieAnimale) as POPOLAZIONE_SPECIE
FROM ANIMALE AS an
LEFT JOIN PARCO AS par
ON an.IDParco=par.IDParco
INNER JOIN SPECIEANIMALE AS sp
ON an.IDSpecieAnimale=sp.IDSpecieAnimale
WHERE par.Nome_Parco='SERRE' AND an.IDEstinzione IN(
												    SELECT IDEstinzione
												    FROM ESTINZIONE
													WHERE IDEstinzione='0-LC'
													)
GROUP BY sp.NomeSpecieAnimale,sp.IDSpecieAnimale,par.IDParco,par.Nome_Parco 

--------MOSTRA POPOLAZIONE TOTALE PER SPECIE ANIMALE
SELECT sp.NomeSpecieAnimale,count(*) as POPOLAZIONE_TOTALE
FROM ANIMALE AS an
INNER JOIN SPECIEANIMALE AS sp
ON an.IDSpecieAnimale=sp.IDSpecieAnimale
GROUP BY an.IDSpecieAnimale, sp.NomeSpecieAnimale


---MOSTRA POPOLAZIONE TOTALE PER ORDINE-- CREARE VISTA!!

SELECT ord.NomeOrdineAnimale, count(*) AS Popolazione_Totale
FROM ANIMALE AS an
INNER JOIN ORDINEANIMALE AS ord
ON an.IDOrdineAnimale=ord.IDOrdineAnimale
GROUP BY ord.NomeOrdineAnimale

--MOSTRA GLI ANIMALI CON UN CERTO STATO DI SALUTE E UNO STATUS DI ESTINZIONE IN UN'AREA GEOGRAFICA - QUERY INNESTATE IN FROM E WHEN */


SELECT filt1.IDAnimale, filt1.NomeSpecieAnimale, filt1.IDSpecieAnimale, par.IDPosizione, par.Nome_Parco
FROM (
	  SELECT an1.IDParco, sp1.NomeSpecieAnimale, an1.IDSpecieAnimale, an1.IDAnimale,an1.IDEstinzione
	  FROM ANIMALE as an1
	  INNER JOIN SPECIEANIMALE as sp1
	  ON an1.IDSpecieAnimale=sp1.IDSpecieAnimale
     ) AS filt1
INNER JOIN PARCO AS par ON filt1.IDParco =par.IDParco
WHERE par.IDPosizione = 'NORD' AND filt1.IDEstinzione IN (
															SELECT est.IDEstinzione
															FROM ESTINZIONE AS est
															WHERE est.IDEstinzione = '0-LC'
															GROUP BY est.IDEstinzione
														 )
GROUP BY filt1.IDAnimale, filt1.NomeSpecieAnimale, filt1.IDSpecieAnimale, par.IDPosizione, par.Nome_Parco

-- MOSTRARE GLI ANIMALI CHE APPARTENGONO IN UN ORDINE, DENTRO UNA REGIONE --

SELECT regio.Nome_Regione, an.IDAnimale, an.Età
FROM ( SELECT pa.IDRegione, reg.Nome_Regione,pa.IDParco
	   FROM REGIONE AS reg
	   INNER JOIN PARCO AS pa
	   ON reg.IDRegione=pa.IDRegione
	   WHERE reg.Nome_Regione='UMBRIA'
	   ) as regio
INNER JOIN ANIMALE as an
ON regio.IDParco=an.IDParco
WHERE an.IDOrdineAnimale IN ( SELECT ord1.IDOrdineAnimale
							  FROM ORDINEANIMALE AS ord1
						      WHERE ord1.IDOrdineAnimale='MAM01'
							  GROUP BY ord1.IDOrdineAnimale
							  )
GROUP BY regio.Nome_Regione, an.IDAnimale, an.Età

-----MOSTRARE, PER SPECIE ANIMALE, LA PREVISIONE DI MORTE "NATURALE" RISPETTO ALL'ETA' MEDIA DELLA vita media per specie animale
--1parte

DECLARE @STIMAVITAALICE INT; SET @STIMAVITAALICE=4;
DECLARE @STIMAVITAAQUILA INT; SET @STIMAVITAAQUILA=20;
DECLARE @STIMAVITACARDELLINO INT; SET @STIMAVITACARDELLINO=4;
DECLARE @STIMAVITACAPRIOLO INT; SET @STIMAVITACAPRIOLO=14;
DECLARE @STIMAVITACERVO INT; SET @STIMAVITACERVO=17;
DECLARE @STIMAVITACINGHIALE INT; SET @STIMAVITACINGHIALE=25;
DECLARE @STIMAVITADELFINO INT; SET @STIMAVITADELFINO=30;
DECLARE @STIMAVITADENTICE INT; SET @STIMAVITADENTICE=25;
DECLARE @STIMAVITAFALCO INT; SET @STIMAVITAFALCO=17;
DECLARE @STIMAVITAGUFO INT; SET @STIMAVITAGUFO=20;
DECLARE @STIMAVITALUPO INT; SET @STIMAVITALUPO=16;
DECLARE @STIMAVITALUCERTOLA INT; SET @STIMAVITALUCERTOLA=15;
DECLARE @STIMAVITALUCCIO INT; SET @STIMAVITALUCCIO=12;
DECLARE @STIMAVITAORSO INT; SET @STIMAVITAORSO=25;
DECLARE @STIMAVITAORATA INT; SET @STIMAVITAORATA=10;
DECLARE @STIMAVITAPESCESPADA INT; SET @STIMAVITAPESCESPADA=13;
DECLARE @STIMAVITASALAMANDRA INT; SET @STIMAVITASALAMANDRA=20;
DECLARE @STIMAVITASCOIATTOLO INT; SET @STIMAVITASCOIATTOLO=3;
DECLARE @STIMAVITASTAMBECCO INT; SET @STIMAVITASTAMBECCO=15;
DECLARE @STIMAVITASTORIONE INT; SET @STIMAVITASTORIONE=100;
DECLARE @STIMAVITATRITONE INT; SET @STIMAVITATRITONE=6;
DECLARE @STIMAVITATROTA INT; SET @STIMAVITATROTA=8;
DECLARE @STIMAVITAVIPERA INT; SET @STIMAVITAVIPERA=20;
DECLARE @STIMAVITAVOLPE INT; SET @STIMAVITAVOLPE=3;



SELECT sp.NomeSpecieAnimale, AVG(an.età) as Età_Media,
       CASE sp.IDSpecieAnimale
            WHEN 'AL11' THEN @STIMAVITAALICE - AVG(an.età)
		    WHEN 'AQ06' THEN @STIMAVITAAQUILA - AVG(an.età)
			WHEN 'CA57' THEN @STIMAVITACARDELLINO - AVG(an.età)
			WHEN 'CA99' THEN @STIMAVITACAPRIOLO - AVG(an.età)
			WHEN 'CE45' THEN @STIMAVITACERVO - AVG(an.età)
			WHEN 'CI89' THEN @STIMAVITACINGHIALE - AVG(an.età)
			WHEN 'DE12' THEN @STIMAVITADELFINO - AVG(an.età)
			WHEN 'DE32' THEN @STIMAVITADENTICE - AVG(an.età)
			WHEN 'FA05' THEN @STIMAVITAFALCO - AVG(an.età)
			WHEN 'GU07' THEN @STIMAVITAGUFO - AVG(an.età)
			WHEN 'LU01' THEN @STIMAVITALUPO - AVG(an.età)
			WHEN 'LU09' THEN @STIMAVITALUCERTOLA - AVG(an.età)
			WHEN 'LU69' THEN @STIMAVITALUCCIO - AVG(an.età)
			WHEN 'OR02' THEN @STIMAVITAORSO - AVG(an.età)
			WHEN 'OR78' THEN @STIMAVITAORATA - AVG(an.età)
			WHEN 'PS87' THEN @STIMAVITAPESCESPADA - AVG(an.età)
			WHEN 'SA62' THEN @STIMAVITASALAMANDRA - AVG(an.età)
			WHEN 'SC04' THEN @STIMAVITASCOIATTOLO - AVG(an.età)
			WHEN 'ST31' THEN @STIMAVITASTAMBECCO - AVG(an.età)
			WHEN 'ST78' THEN @STIMAVITASTORIONE - AVG(an.età)
			WHEN 'TR21' THEN @STIMAVITATRITONE - AVG(an.età)
			WHEN 'TR34' THEN @STIMAVITATROTA - AVG(an.età)
			WHEN 'VI08' THEN @STIMAVITAVIPERA - AVG(an.età)
			WHEN 'VO03' THEN @STIMAVITAVOLPE - AVG(an.età)

          ELSE NULL
       END AS AnniRimanentiMorteNaturale
FROM ANIMALE AS an
INNER JOIN SPECIEANIMALE AS sp
ON an.IDSpecieAnimale=sp.IDSpecieAnimale
GROUP BY sp.NomeSpecieAnimale, sp.IDSpecieAnimale


--MOSTRA GLI ANIMALI CHE APPARTENGONO IN UNA CERTA AREA GEOGRAFICA, 
--DI UN CERTA SPECIE ANIMALE 
--CHE APPARTENGONO AD UN RESPONSABILE


SELECT FiltroAquila.NomeSpecieAnimale, GuardiaCaccia.GuardiaCaccia, par.Nome_Parco, par.IDPosizione, COUNT(FiltroAquila.NomeSpecieAnimale) AS Popolazione
FROM 
	(
	 SELECT sp.NomeSpecieAnimale, an1.IDParco
	 FROM ANIMALE AS an1
     INNER JOIN SPECIEANIMALE AS sp
	 ON an1.IDSpecieAnimale=sp.IDSpecieAnimale
     WHERE sp.NomeSpecieAnimale='AQUILA' ) AS FiltroAquila,


	(SELECT parc.IDParco, resp1.IDResponsabile, CONCAT(resp1.Nome,' ', resp1.Cognome) AS GuardiaCaccia
	 FROM RESPONSABILE AS resp1
     INNER JOIN PARCO AS parc
      ON resp1.IDResponsabile=parc.IDResponsabile) AS GuardiaCaccia

INNER JOIN PARCO AS par
ON GuardiaCaccia.IDParco=par.IDParco
WHERE par.IDPosizione='NORD' 

AND par.IDResponsabile IN ( SELECT resp.IDResponsabile
														   FROM PARCO AS par2
														   INNER JOIN ANIMALE AS an2
														   ON par2.IDParco=an2.IDParco
														   INNER JOIN RESPONSABILE AS resp
														   ON resp.IDResponsabile=par2.IDResponsabile
														   WHERE resp.IDResponsabile='101'
														  )
GROUP BY FiltroAquila.NomeSpecieAnimale, GuardiaCaccia.GuardiaCaccia, par.Nome_Parco, par.IDPosizione

----UTILIZZANDO LA HAVING
SELECT FiltroAquila.NomeSpecieAnimale,GuardiaCaccia.IDResponsabile, GuardiaCaccia.GuardiaCaccia, par.Nome_Parco, par.IDPosizione, COUNT(FiltroAquila.NomeSpecieAnimale) AS Popolazione
FROM 
	(
	 SELECT sp.NomeSpecieAnimale, an1.IDParco
	 FROM ANIMALE AS an1
     INNER JOIN SPECIEANIMALE AS sp
	 ON an1.IDSpecieAnimale=sp.IDSpecieAnimale
     WHERE sp.NomeSpecieAnimale='AQUILA' ) AS FiltroAquila,


	(SELECT parc.IDParco, resp1.IDResponsabile, CONCAT(resp1.Nome,' ', resp1.Cognome) AS GuardiaCaccia
	 FROM RESPONSABILE AS resp1
     INNER JOIN PARCO AS parc
      ON resp1.IDResponsabile=parc.IDResponsabile) AS GuardiaCaccia

INNER JOIN PARCO AS par
ON GuardiaCaccia.IDParco=par.IDParco
WHERE par.IDPosizione='NORD' 
GROUP BY FiltroAquila.NomeSpecieAnimale,GuardiaCaccia.IDResponsabile, GuardiaCaccia.GuardiaCaccia, par.Nome_Parco, par.IDPosizione
HAVING GuardiaCaccia.IDResponsabile='101'
