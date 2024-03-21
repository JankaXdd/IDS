/*
IDS projekt: 2. část - SQL skript pro vytvoření objektů schématu databáze
Autoři: 
  - Jana Veronika Moskvová (xmoskv01)
  - Petr Plíhal            (xpliha02)
*/

-- DROP pro testování změn
-- Při vytváření tabulek poprvé je třeba odmazat/zakomentovat/označit bez
DROP TABLE PredepsanyLek;
DROP TABLE ProvedenyVykon;
DROP TABLE Vykon;
DROP TABLE Lek;
DROP TABLE Vysetreni;
DROP TABLE Ockovani;
DROP TABLE Faktura;
DROP TABLE Navsteva;
DROP TABLE Pacient;

create table Pacient
(
    rodneCislo number(10) check (mod(rodneCislo,11)=0) primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    datumNarozeni date not null,
    ulice nvarchar2(255), -- Některé oblasti nemají pojmenované ulice
    mesto nvarchar2(255) not null,
    psc number(5) not null,
    telefon int not null,
    cisloPojistence int not null -- Nemusí být vždy totožné s rodným číslem
);

create table Navsteva
(
    idNavstevy int GENERATED BY DEFAULT as identity primary key,
    datum date not null,
    cas date not null,
    rodneCislo int REFERENCES Pacient(rodneCislo)
);

create table Faktura
(
    idFaktury int GENERATED BY DEFAULT as identity primary key,
    castka decimal(18,2) check (castka >= 0),
    datumVystaveni date not null,
    popis nvarchar2(255) not null,
    datumSplatnosti date not null,
    idNavstevy int REFERENCES Navsteva(idNavstevy)
);

create table Ockovani
(
    idNavstevy int primary key references Navsteva(idNavstevy) ON DELETE CASCADE,
    typ nvarchar2(255) not null,
    expirace date not null
);

create table Vysetreni
(
    idNavstevy int primary key references Navsteva(idNavstevy) ON DELETE CASCADE,
    typ nvarchar2(255) not null,
    planovaneVykony nvarchar2(255) not null,
    zazadanaVysetreni nvarchar2(255) not null,
    lekarskaZprava nvarchar2(255) not null
);

create table Lek
(
    idLeku int primary key,
    typ nvarchar2(255) not null,
    davkovani nvarchar2(255) not null,
    nazev nvarchar2(255) not null,
    ucinnaLatka nvarchar2(255) not null
);

create table Vykon
(
    idVykonu int primary key,
    nazevVykonu nvarchar2(255),
    popis nvarchar2(255)
);

create table ProvedenyVykon
(
    idNavstevy int REFERENCES Vysetreni(idNavstevy),
    idVykonu int REFERENCES  Vykon(idVykonu),
    primary key (idNavstevy, idVykonu)
);

create table PredepsanyLek
(
    idNavstevy int REFERENCES Vysetreni(idNavstevy),
    idLeku int REFERENCES Lek(idLeku),
    primary key (idNavstevy, idLeku)
);

create table ProvedenyVykon
(
    idNavstevy int REFERENCES Vysetreni(idNavstevy),
    idVykonu int REFERENCES  Vykon(idVykonu),
    primary key (idNavstevy, idVykonu)
);