-------------------------------

CREATE VIEW Np_VCOUNTORDINEANIMALE AS

SELECT ord.NomeOrdineAnimale, an.IDOrdineAnimale, COUNT(an.IDOrdineAnimale) AS PopolazioneTotale
FROM ANIMALE AS an
INNER JOIN ORDINEANIMALE AS ord
ON an.IDOrdineAnimale=ord.IDOrdineAnimale
GROUP BY ord.NomeOrdineAnimale, an.IDOrdineAnimale

-------------------------------

CREATE VIEW Np_COUNTSPECIEANIMALE AS

SELECT an.IDSpecieAnimale,sp.NomeSpecieAnimale,COUNT(an.IDSpecieAnimale) AS PopolazioneTotale
FROM ANIMALE AS an
INNER JOIN SPECIEANIMALE AS sp
ON an.IDSpecieAnimale=sp.IDSpecieAnimale
GROUP BY sp.NomeSpecieAnimale, an.IDSpecieAnimale

-------------------------------
CREATE VIEW Np_COUNTANIMALIREGIONEBYPARCO AS

SELECT reg.IDRegione, reg.Nome_Regione,par.IDParco, par.Nome_Parco , par.IDPosizione ,COUNT(IDAnimale) AS PopolazioneTotale
FROM ANIMALE AS an
INNER JOIN PARCO AS par
ON an.IDParco=par.IDParco
INNER JOIN REGIONE AS reg
ON par.IDRegione=reg.IDRegione
GROUP BY reg.Nome_Regione, reg.IDRegione,par.IDParco,par.Nome_Parco, par.IDPosizione


-------------------------------
CREATE VIEW Np_RESPONSABILE AS

SELECT resp.IDResponsabile, par.IDParco, CONCAT(resp.Nome,' ', resp.Cognome) AS GuardiaCaccia,resp.Sesso, resp.Data_Nascita, resp.DataAssunzione
FROM RESPONSABILE AS resp
INNER JOIN PARCO AS par
ON resp.IDResponsabile=par.IDResponsabile
---------------------------




CREATE VIEW Np_INFORMAZIONIPARCHI AS

SELECT par.IDParco, par.Nome_Parco, par.IDPosizione, reg.Nome_Regione, concat(resp.nome,' ',resp.cognome) AS GuardiaCaccia, resp.Sesso
FROM PARCO AS par
INNER JOIN RESPONSABILE AS resp
ON par.IDResponsabile=resp.IDResponsabile
INNER JOIN REGIONE as reg
ON par.IDRegione=reg.IDRegione
