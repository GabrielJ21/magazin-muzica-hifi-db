CREATE TYPE tip_produs_enum AS ENUM ('MUZICA', 'ECHIPAMENT');
CREATE TYPE tip_artist_enum AS ENUM ('TRUPA', 'SOLIST', 'ORCHESTRA');
CREATE TYPE tip_album_enum AS ENUM ('STUDIO', 'LIVE', 'COMPILATIE', 'EP');
CREATE TYPE format_fizic_enum AS ENUM ('VINIL_LP', 'VINIL_7', 'CD', 'CASETA');
CREATE TYPE tip_furnizor_enum AS ENUM ('DISTRIBUITOR', 'ANTICARIAT', 'COLECTIONAR');
CREATE TYPE grad_stare_enum AS ENUM ('M', 'NM', 'VG+', 'VG', 'G');
CREATE TYPE status_stoc_enum AS ENUM ('DISPONIBIL', 'REZERVAT', 'VANDUT');
CREATE TYPE rol_utilizator_enum AS ENUM ('CLIENT', 'OPERATOR_STOC', 'ADMIN');
CREATE TYPE status_comanda_enum AS ENUM ('PLASATA', 'ACHITATA', 'EXPEDIATA', 'FINALIZATA', 'ANULATA');
CREATE TYPE metoda_plata_enum AS ENUM ('CARD', 'RAMBURS', 'TRANSFER');


-- Tabele independente, fara FK

CREATE TABLE produs (
    id_produs SERIAL PRIMARY KEY,
    cod_sku VARCHAR(50) NOT NULL UNIQUE,
    denumire_comerciala VARCHAR(200) NOT NULL,
    tip_produs tip_produs_enum NOT NULL,
    descriere TEXT,
    data_adaugare TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE artist (
    id_artist SERIAL PRIMARY KEY,
    nume_artist VARCHAR(150) NOT NULL,
    tip_artist tip_artist_enum NOT NULL,
    tara_origine VARCHAR(60)
);

CREATE TABLE album (
    id_album SERIAL PRIMARY KEY,
    titlu_album VARCHAR(200) NOT NULL,
    an_lansare_initial SMALLINT NOT NULL CHECK (an_lansare_initial BETWEEN 1900 AND 2100),
    gen_muzical VARCHAR(80) NOT NULL,
    tip_album tip_album_enum NOT NULL
);

CREATE TABLE casa_discuri (
    id_casa_discuri SERIAL PRIMARY KEY,
    nume_casa VARCHAR(150) NOT NULL UNIQUE,
    tara_sediu VARCHAR(60)
);

CREATE TABLE categorie_echipament (
    id_categorie SERIAL PRIMARY KEY,
    nume_categorie VARCHAR(100) NOT NULL UNIQUE,
    descriere_categorie TEXT
);

CREATE TABLE furnizor (
    id_furnizor SERIAL PRIMARY KEY,
    nume_furnizor VARCHAR(150) NOT NULL,
    tip_furnizor tip_furnizor_enum NOT NULL,
    cui_identificator VARCHAR(30) NOT NULL UNIQUE,
    telefon VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE utilizator (
    id_utilizator SERIAL PRIMARY KEY,
    nume_complet VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    parola_hash VARCHAR(255) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    rol rol_utilizator_enum NOT NULL DEFAULT 'CLIENT',
    adresa_implicita TEXT
);


-- Catalog muzical si subtipuri produs

CREATE TABLE album_artist (
    id_album INT NOT NULL REFERENCES album(id_album) ON DELETE CASCADE,
    id_artist INT NOT NULL REFERENCES artist(id_artist) ON DELETE CASCADE,
    rol_contributie VARCHAR(80),
    PRIMARY KEY (id_album, id_artist)
);

CREATE TABLE piesa (
    id_album INT NOT NULL REFERENCES album(id_album) ON DELETE CASCADE,
    numar_ordine SMALLINT NOT NULL CHECK (numar_ordine > 0),
    titlu_piesa VARCHAR(200) NOT NULL,
    durata_secunde INT NOT NULL CHECK (durata_secunde > 0),
    PRIMARY KEY (id_album, numar_ordine)
);

CREATE TABLE editie_muzicala (
    id_produs INT PRIMARY KEY REFERENCES produs(id_produs) ON DELETE CASCADE,
    id_album INT NOT NULL REFERENCES album(id_album),
    id_casa_discuri INT NOT NULL REFERENCES casa_discuri(id_casa_discuri),
    format_fizic format_fizic_enum NOT NULL,
    numar_catalog VARCHAR(50) NOT NULL,
    an_editie SMALLINT NOT NULL CHECK (an_editie BETWEEN 1900 AND 2100),
    numar_suporturi SMALLINT NOT NULL DEFAULT 1 CHECK (numar_suporturi > 0),
    tara_presare VARCHAR(60),
    viteza_rpm SMALLINT CHECK (viteza_rpm IN (33, 45, 78)),
    greutate_grame SMALLINT CHECK (greutate_grame > 0),
    cod_matrita VARCHAR(100)
);

CREATE TABLE echipament_audio (
    id_produs INT PRIMARY KEY REFERENCES produs(id_produs) ON DELETE CASCADE,
    id_categorie INT NOT NULL REFERENCES categorie_echipament(id_categorie),
    producator VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    garantie_luni SMALLINT NOT NULL DEFAULT 24 CHECK (garantie_luni >= 0),
    impedanta_ohmi NUMERIC(8,2) CHECK (impedanta_ohmi > 0),
    putere_wati NUMERIC(6,2) CHECK (putere_wati > 0),
    tip_conectori VARCHAR(150),
    specificatii_montura VARCHAR(150)
);

CREATE TABLE compatibilitate_tehnica (
    id_echipament_sursa INT NOT NULL REFERENCES echipament_audio(id_produs) ON DELETE CASCADE,
    id_echipament_tinta INT NOT NULL REFERENCES echipament_audio(id_produs) ON DELETE CASCADE,
    tip_compatibilitate VARCHAR(50) NOT NULL,
    observatii_tehnice VARCHAR(255),
    PRIMARY KEY (id_echipament_sursa, id_echipament_tinta),
    CHECK (id_echipament_sursa <> id_echipament_tinta)
);



-- gestiune stoc si comenzi

CREATE TABLE nota_receptie (
    id_receptie SERIAL PRIMARY KEY,
    id_furnizor INT NOT NULL REFERENCES furnizor(id_furnizor),
    numar_document_factura VARCHAR(50) NOT NULL,
    data_receptie DATE NOT NULL DEFAULT CURRENT_DATE,
    total_valoare_intrare NUMERIC(10,2) NOT NULL CHECK (total_valoare_intrare >= 0)
);

CREATE TABLE exemplar_stoc (
    id_exemplar SERIAL PRIMARY KEY,
    id_produs INT NOT NULL REFERENCES produs(id_produs),
    id_receptie INT NOT NULL REFERENCES nota_receptie(id_receptie),
    cod_bare_unic VARCHAR(50) NOT NULL UNIQUE,
    este_second_hand BOOLEAN NOT NULL,
    cantitate_stoc INT NOT NULL CHECK (cantitate_stoc >= 0),
    grad_stare_media grad_stare_enum NOT NULL,
    grad_stare_coperta VARCHAR(20),
    status_stoc status_stoc_enum NOT NULL DEFAULT 'DISPONIBIL',
    pret_achizitie NUMERIC(10,2) NOT NULL CHECK (pret_achizitie >= 0),
    pret_vanzare NUMERIC(10,2) NOT NULL CHECK (pret_vanzare > 0),
    locatie_raft VARCHAR(50),
    -- Regula de gestiune: un produs second-hand este unicat (max 1 bucata pe rand)
    CHECK (NOT este_second_hand OR cantitate_stoc <= 1)
);

CREATE TABLE comanda (
    id_comanda SERIAL PRIMARY KEY,
    id_utilizator INT NOT NULL REFERENCES utilizator(id_utilizator),
    data_plasare TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_comanda status_comanda_enum NOT NULL DEFAULT 'PLASATA',
    metoda_plata metoda_plata_enum NOT NULL,
    adresa_livrare TEXT NOT NULL
);

CREATE TABLE detalii_comanda (
    id_comanda INT NOT NULL REFERENCES comanda(id_comanda) ON DELETE CASCADE,
    id_exemplar INT NOT NULL REFERENCES exemplar_stoc(id_exemplar),
    cantitate_comandata INT NOT NULL CHECK (cantitate_comandata > 0),
    pret_vanzare_final NUMERIC(10,2) NOT NULL CHECK (pret_vanzare_final >= 0),
    PRIMARY KEY (id_comanda, id_exemplar)
);