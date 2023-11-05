CREATE TABLE REGIONE(
					 IDRegione VARCHAR(15),
					 Nome_Regione VARCHAR(50),

CONSTRAINT PK_IDRegione PRIMARY KEY (IDRegione)
					
					)


CREATE TABLE RESPONSABILE(
							IDResponsabile INT,
							Nome VARCHAR(20),
							Cognome VARCHAR(20),
							Data_Nascita DATE,
							Telefono VARCHAR(25),
							Mail VARCHAR(50),
							Sesso VARCHAR(3),
							Curr INT

CONSTRAINT PK_IDResponsabile PRIMARY KEY (IDResponsabile)
						)


CREATE TABLE PARCO(
					IDParco VARCHAR(15),
					Nome_Parco VARCHAR(60),
					IDRegione VARCHAR(15),
					IDResponsabile INT,
					IDPosizione VARCHAR(10)

CONSTRAINT PK_IDParco PRIMARY KEY (IDParco),
CONSTRAINT FK_PARCO_REGIONE_IDRegione FOREIGN KEY (IDRegione) REFERENCES REGIONE(IDRegione),
CONSTRAINT FK_PARCO_RESPONSABILE_IDResponsabile FOREIGN KEY (IDResponsabile) REFERENCES RESPONSABILE(IDResponsabile)
CONSTRAINT FK_PARCO_POSIZIONE_IDPosizione FOREIGN KEY(IDPosizione) REFERENCES POSIZIONE(IDPosizione)				)

CREATE TABLE ESTINZIONE(
						IDEstinzione VARCHAR(20),
						Descrizione VARCHAR(100)

CONSTRAINT PK_IDEstinzione PRIMARY KEY (IDEstinzione)
						)

CREATE TABLE STATOSALUTE(
							IDStatoSalute VARCHAR(10),
							Descrizione VARCHAR(20)

CONSTRAINT PK_IDStatoSalute PRIMARY KEY (IDStatoSalute)
						)


CREATE TABLE SPECIEANIMALE(
							IDSpecieAnimale VARCHAR(40),
							NomeSpecieAnimale VARCHAR(100)

CONSTRAINT PK_IDSpecieAnimale PRIMARY KEY (IDSpecieAnimale)
							)

CREATE TABLE ORDINEANIMALE(
							IDOrdineAnimale VARCHAR(40),
							NomeOrdineAnimale VARCHAR(100)

CONSTRAINT PK_IDOrdineAnimale PRIMARY KEY (IDOrdineAnimale)
							)

CREATE TABLE ANIMALE(
					  IDAnimale VARCHAR(40),
					  Sesso VARCHAR(2),
					  Età INT,
					  IDParco VARCHAR(15),
					  IDStatoSalute VARCHAR(10),
					  IDSpecieAnimale VARCHAR(40),
					  IDOrdineAnimale VARCHAR(40),
					  IDEstinzione VARCHAR(20),
					  
					  
CONSTRAINT PK_IDAnimale PRIMARY KEY (IDAnimale),
CONSTRAINT FK_ANIMALE_SPECIEANIMALE_IDSpecieAnimale FOREIGN KEY (IDSpecieAnimale) REFERENCES SPECIEANIMALE(IDSpecieAnimale),
CONSTRAINT FK_ANIMALE_ORDINEANIMALE_IDOrdineAnimale FOREIGN KEY (IDOrdineAnimale) REFERENCES ORDINEANIMALE(IDOrdineAnimale),
CONSTRAINT FK_ANIMALE_ESTINZIONE_IDEstinzione FOREIGN KEY(IDEstinzione) REFERENCES ESTINZIONE (IDEstinzione),
CONSTRAINT FK_ANIMALE_STATOSALUTE_IDStatoSalute FOREIGN KEY(IDStatoSalute) REFERENCES STATOSALUTE(IDStatoSalute),
CONSTRAINT FK_ANIMALE_PARCO_IDParco FOREIGN KEY(IDParco) REFERENCES PARCO(IDParco),
					)


CREATE TABLE POSIZIONE(
						IDPosizione VARCHAR(10)

CONSTRAINT PK_Posizione PRIMARY KEY(IDPosizione)

						)