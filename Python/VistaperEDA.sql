

SELECT an.IDAnimale, an.Sesso, an.Età,an.AnnoNascita,par.Nome_Parco,sp.NomeSpecieAnimale,ord.NomeOrdineAnimale,st.Descrizione
 FROM ANIMALE AS an
 INNER JOIN PARCO AS par
 ON an.IDParco=par.IDParco
 INNER JOIN STATOSALUTE AS st
 ON an.IDStatoSalute= st.IDStatoSalute
 INNER JOIN SPECIEANIMALE AS sp
 ON an.IDSpecieAnimale=sp.IDSpecieAnimale
 INNER JOIN ORDINEANIMALE AS ord
 ON an.IDOrdineAnimale=ORD.IDOrdineAnimale