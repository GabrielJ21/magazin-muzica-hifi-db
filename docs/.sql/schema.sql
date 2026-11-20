TRUNCATE TABLE
    detalii_comanda, comanda, exemplar_stoc, nota_receptie,
    compatibilitate_tehnica, echipament_audio, editie_muzicala,
    piesa, album_artist, utilizator, furnizor, categorie_echipament,
    casa_discuri, album, artist, produs
RESTART IDENTITY CASCADE;
-- 1. Artiști
INSERT INTO artist (nume_artist, tip_artist, tara_origine) VALUES
('Pink Floyd', 'TRUPA', 'Marea Britanie'),
('King Crimson', 'TRUPA', 'Marea Britanie'),
('Death', 'TRUPA', 'SUA'),
('David Gilmour', 'SOLIST', 'Marea Britanie'),
('Megadeth', 'TRUPA', 'SUA'),
('Miles Davis', 'SOLIST', 'SUA'),
('Amon Amarth', 'TRUPA', 'Suedia'),
('Opeth', 'TRUPA', 'Suedia'),
('Have a Nice Life', 'TRUPA', 'SUA');

-- 2. Albume (Master)
INSERT INTO album (titlu_album, an_lansare_initial, gen_muzical, tip_album) VALUES
('The Dark Side of the Moon', 1973, 'Progressive Rock', 'STUDIO'),
('In the Court of the Crimson King', 1969, 'Progressive Rock', 'STUDIO'),
('Symbolic', 1995, 'Death Metal', 'STUDIO'),
('Rust in Peace', 1990, 'Thrash Metal', 'STUDIO'),
('Kind of Blue', 1959, 'Jazz', 'STUDIO'),
('Twilight of the Thunder God', 2008, 'Melodic Death Metal', 'STUDIO'),
('Blackwater Park', 2001, 'Progressive Metal', 'STUDIO'),
('Deathconsciousness', 2008, 'Post-Punk / Shoegaze', 'STUDIO');

-- 3. Legături Album - Artist (M:N)
INSERT INTO album_artist (id_album, id_artist, rol_contributie) VALUES
(1, 1, 'Artist Principal'),
(1, 4, 'Chitară / Voce'),
(2, 2, 'Artist Principal'),
(3, 3, 'Artist Principal'),
(4, 5, 'Artist Principal'),
(5, 6, 'Artist Principal'),
(6, 7, 'Artist Principal'),
(7, 8, 'Artist Principal'),
(8, 9, 'Artist Principal');

-- 4. Piese (Entitate slabă)
INSERT INTO piesa (id_album, numar_ordine, titlu_piesa, durata_secunde) VALUES
(1, 1, 'Speak to Me', 67),
(1, 2, 'Breathe (In the Air)', 163),
(1, 3, 'Time', 413),
(1, 4, 'Money', 382),
(2, 1, '21st Century Schizoid Man', 444),
(2, 2, 'Epitaph', 527),
(3, 1, 'Symbolic', 392),
(3, 2, 'Crystal Mountain', 307),
(4, 1, 'Holy Wars... The Punishment Due', 392),
(4, 2, 'Tornado of Souls', 319),

-- Amon Amarth - Twilight of the Thunder God (id_album = 6)
(6, 1, 'Twilight of the Thunder God', 249),
(6, 2, 'Free Will Sacrifice', 249),
(6, 3, 'Guardians of Asgaard', 263),
(6, 4, 'Where Is Your God?', 191),
(6, 5, 'Varyags of Miklagaard', 258),
(6, 6, 'Tattered Banners and Bloody Flags', 270),
(6, 7, 'No Fear for the Setting Sun', 232),
(6, 8, 'The Hero', 242),
(6, 9, 'Live for the Kill', 250),
(6, 10, 'Embrace of the Endless Ocean', 404),

-- Opeth - Blackwater Park (id_album = 7)
(7, 1, 'The Leper Affinity', 623),
(7, 2, 'Bleak', 556),
(7, 3, 'Harvest', 361),
(7, 4, 'The Drapery Falls', 654),
(7, 5, 'Dirge for November', 474),
(7, 6, 'The Funeral Portrait', 524),
(7, 7, 'Patterns in the Ivy', 113),
(7, 8, 'Blackwater Park', 728),

-- Have a Nice Life - Deathconsciousness (id_album = 8)
(8, 1, 'A Quick One Before the Eternal Worm Devours Connecticut', 472),
(8, 2, 'Bloodhail', 340),
(8, 3, 'The Big Gloom', 487),
(8, 4, 'Hunter', 585),
(8, 5, 'Telephony', 278),
(8, 6, 'Who Would Leave Their Son Out in the Sun?', 319),
(8, 7, 'There Is No Food', 240),
(8, 8, 'Waiting for Black Metal Records to Come in the Mail', 377),
(8, 9, 'Holy Fucking Shit: 40,000', 389),
(8, 10, 'The Future', 230),
(8, 11, 'Deep, Deep', 325),
(8, 12, 'I Don''t Love', 373),
(8, 13, 'Earthmover', 688);

-- 5. Case de discuri
INSERT INTO casa_discuri (nume_casa, tara_sediu) VALUES
('Harvest Records', 'Marea Britanie'),
('Island Records', 'Marea Britanie'),
('Roadrunner Records', 'Olanda'),
('Capitol Records', 'SUA'),
('Parlophone', 'Marea Britanie'),
('Metal Blade Records', 'SUA'),
('Music for Nations', 'Marea Britanie'),
('The Flenser', 'SUA');

-- 6. Categorii echipamente
INSERT INTO categorie_echipament (nume_categorie, descriere_categorie) VALUES
('Pickup', 'Pick-up-uri cu tracțiune directă, pe curea sau pe rolă intermediară'),
('Amplificator', 'Amplificatoare stereo integrate și amplificatoare dedicate pentru căști'),
('Doză Pickup', 'Doze magnetice MM și MC pentru brațe de pickup'),
('Preamplificator Phono', 'Preamplificatoare RIAA pentru semnal de nivel phono'),
('Căști Audio', 'Căști planare și dinamice pentru audiție Hi-Fi');

-- 7. Produse (Supratip: IDs 1..6 Muzică, IDs 7..12 Echipamente)
INSERT INTO produs (cod_sku, denumire_comerciala, tip_produs, descriere) VALUES
('MUZ-PF-73LP', 'Pink Floyd - The Dark Side of the Moon (Presare 1973 UK)', 'MUZICA', 'Ediție timpurie Harvest Records cu coperte gatefold'),
('MUZ-PF-16LP', 'Pink Floyd - The Dark Side of the Moon (Reeditare 2016 180g)', 'MUZICA', 'Remaster analogic pe vinil greu de 180g'),
('MUZ-KC-69LP', 'King Crimson - In the Court of the Crimson King (LP)', 'MUZICA', 'Reeditare audiophile 200g'),
('MUZ-DT-95CD', 'Death - Symbolic (CD Original 1995)', 'MUZICA', 'Prima ediție europeană pe CD, carcasă jewel case'),
('MUZ-MD-90LP', 'Megadeth - Rust in Peace (Vinil LP)', 'MUZICA', 'Presare pe vinil 180g, mix original'),
('MUZ-MD-90CS', 'Megadeth - Rust in Peace (Casetă Audio)', 'MUZICA', 'Ediție pe casetă magnetică'),
('EQ-DUAL-1214', 'Dual 1214 Vintage Turntable', 'ECHIPAMENT', 'Pickup mecanic german cu tracțiune pe rolă și schimbător automat'),
('EQ-AT-VM95E', 'Audio-Technica AT-VM95E', 'ECHIPAMENT', 'Doză electromagnetică MM cu ac eliptic'),
('EQ-PRJ-PHONO', 'Pro-Ject Phono Box E', 'ECHIPAMENT', 'Preamplificator phono compact dedicat dozelor MM'),
('EQ-YAM-AS301', 'Yamaha A-S301', 'ECHIPAMENT', 'Amplificator stereo integrat cu DAC încorporat și intrare Phono'),
('EQ-HFM-400SE', 'HiFiMAN HE400se', 'ECHIPAMENT', 'Căști open-back cu drivere planar-magnetice'),
('EQ-LD-HPA4', 'LD Systems HPA 4', 'ECHIPAMENT', 'Amplificator de căști cu 4 canale independente'),
('MUZ-AA-08LP', 'Amon Amarth - Twilight of the Thunder God (Vinil LP)', 'MUZICA', 'Ediție pe vinil 180g cu copertă gatefold'),
('MUZ-OP-01LP', 'Opeth - Blackwater Park (2xLP Presare 2001)', 'MUZICA', 'Prima presare europeană pe dublu vinil, copertă gatefold'),
('MUZ-HANL-14LP', 'Have a Nice Life - Deathconsciousness (2xLP + Booklet)', 'MUZICA', 'Reeditare dublu vinil însoțită de broșura de 75 de pagini');

-- 8. Ediții muzicale (Subtip 1:1)
INSERT INTO editie_muzicala (id_produs, id_album, id_casa_discuri, format_fizic, numar_catalog, an_editie, numar_suporturi, tara_presare, viteza_rpm, greutate_grame, cod_matrita) VALUES
(1, 1, 1, 'VINIL_LP', 'SHVL 804', 1973, 1, 'Marea Britanie', 33, 140, 'SHVL 804 A-3 / B-3'),
(2, 1, 5, 'VINIL_LP', 'PFRLP8', 2016, 1, 'UE', 33, 180, 'BG35147-01 A1'),
(3, 2, 2, 'VINIL_LP', 'KCLP1', 2010, 1, 'Marea Britanie', 33, 200, 'KCLP1-A / B'),
(4, 3, 3, 'CD', 'RR 8957-2', 1995, 1, 'Germania', NULL, NULL, 'SONOPRESS K-0641'),
(5, 4, 4, 'VINIL_LP', 'EST 2132', 2008, 1, 'SUA', 33, 180, '007243591021'),
(6, 4, 4, 'CASETA', 'TC-EST 2132', 1990, 1, 'Marea Britanie', NULL, NULL, NULL),
(13, 6, 6, 'VINIL_LP', '3984-14693-1', 2008, 1, 'Germania', 33, 180, 'MBR-14693-A1 / B1'),
(14, 7, 7, 'VINIL_LP', 'MFN 264', 2001, 2, 'Marea Britanie', 33, 180, 'MFN-264-A / D'),
(15, 8, 8, 'VINIL_LP', 'FR42', 2014, 2, 'SUA', 33, 180, 'PIRATES PRESS - FR42');

-- 9. Echipamente audio (Subtip 1:1)
INSERT INTO echipament_audio (id_produs, id_categorie, producator, model, garantie_luni, impedanta_ohmi, putere_wati, tip_conectori, specificatii_montura) VALUES
(7, 1, 'Dual', '1214', 6, NULL, NULL, 'DIN 5-pini', 'Idler-Drive, montură 1/2 inch'),
(8, 3, 'Audio-Technica', 'AT-VM95E', 24, 47000.00, NULL, '4-pini headshell', 'MM, montură standard 1/2 inch'),
(9, 4, 'Pro-Ject', 'Phono Box E', 24, 47000.00, NULL, 'RCA In / RCA Out', 'Compatibil doze MM'),
(10, 2, 'Yamaha', 'A-S301', 24, 8.00, 60.00, 'RCA, Optic, Coaxial, Jack 6.3mm', 'Integrat stereo, etaj Phono MM'),
(11, 5, 'HiFiMAN', 'HE400se', 24, 25.00, NULL, 'Jack 3.5mm + adaptor 6.3mm', 'Planar-magnetic, open-back'),
(12, 2, 'LD Systems', 'HPA 4', 24, 8.00, 0.10, 'RCA In, Jack 6.3mm Out', 'Amplificator căști 4 canale');

-- 10. Compatibilitate tehnică (M:N recursiv)
INSERT INTO compatibilitate_tehnica (id_echipament_sursa, id_echipament_tinta, tip_compatibilitate, observatii_tehnice) VALUES
(7, 8, 'DIRECTA', 'Brațul Dual 1214 acceptă montura standard 1/2 inch a dozei AT-VM95E'),
(7, 9, 'NECESITA_ADAPTOR', 'Necesită cablu adaptor DIN 5-pini la RCA cu fir separat de împământare'),
(9, 10, 'DIRECTA', 'Conectare directă RCA pe una dintre intrările de linie ale amplificatorului'),
(11, 12, 'RECOMANDATA', 'Oferă rezerva de curent necesară pentru a pilota corect driverele planare de 25 ohmi'),
(11, 10, 'DIRECTA', 'Conectare directă prin adaptorul 6.3mm pe ieșirea frontală de căști');

-- 11. Furnizori
INSERT INTO furnizor (nume_furnizor, tip_furnizor, cui_identificator, telefon, email) VALUES
('Vinyl Distribution Europe SRL', 'DISTRIBUITOR', 'RO31245678', '0214550101', 'comenzi@vde-music.ro'),
('Audio Hi-Fi Import SRL', 'DISTRIBUITOR', 'RO29876543', '0264410220', 'b2b@audiohifi.ro'),
('Anticariatul Melomanului SRL', 'ANTICARIAT', 'RO41122334', '0744112233', 'stoc@melomanul.ro'),
('Popescu Andrei (Colecție Privată)', 'COLECTIONAR', 'CNP-1820514240011', '0722998877', 'andrei.popescu@mail.ro');

-- 12. Note de recepție (NIR)
INSERT INTO nota_receptie (id_furnizor, numar_document_factura, data_receptie, total_valoare_intrare) VALUES
(1, 'FACT-2026-0142', '2026-10-05', 2305.00),
(2, 'FACT-2026-0889', '2026-10-12', 6950.00),
(4, 'BORD-2026-0019', '2026-10-20', 800.00),
(3, 'FACT-2026-0301', '2026-11-02', 240.00),
(1, 'FACT-2026-0215', '2026-11-15', 670.00),
(4, 'BORD-2026-0024', '2026-11-16', 220.00);

-- 13. Exemplare în stoc (Notă: Produsul 6 nu are stoc intenționat!)
INSERT INTO exemplar_stoc (id_produs, id_receptie, cod_bare_unic, este_second_hand, cantitate_stoc, grad_stare_media, grad_stare_coperta, status_stoc, pret_achizitie, pret_vanzare, locatie_raft) VALUES
(1, 3, 'BAR-SH-0001', TRUE,  1, 'NM',  'VG+',       'DISPONIBIL', 350.00, 680.00, 'R1-A1'),
(1, 4, 'BAR-SH-0002', TRUE,  1, 'VG',  'G',         'DISPONIBIL', 180.00, 340.00, 'R1-A2'),
(2, 1, 'BAR-NW-0003', FALSE, 12, 'M',  'M',         'DISPONIBIL', 110.00, 185.00, 'R1-B1'),
(3, 1, 'BAR-NW-0004', FALSE, 5,  'M',  'M',         'DISPONIBIL', 105.00, 175.00, 'R1-B2'),
(4, 4, 'BAR-SH-0005', TRUE,  0,  'VG+','VG+',       'VANDUT',      60.00, 125.00, 'R2-C1'),
(5, 1, 'BAR-NW-0006', FALSE, 4,  'M',  'M',         'DISPONIBIL', 115.00, 195.00, 'R1-B4'),
(7, 3, 'BAR-SH-0007', TRUE,  1,  'VG+','FARA_CUTIE','DISPONIBIL', 450.00, 890.00, 'D1-EQ1'),
(8, 2, 'BAR-NW-0008', FALSE, 8,  'M',  'M',         'DISPONIBIL', 160.00, 265.00, 'D1-EQ2'),
(9, 2, 'BAR-NW-0009', FALSE, 3,  'M',  'M',         'DISPONIBIL', 240.00, 380.00, 'D1-EQ3'),
(10,2, 'BAR-NW-0010', FALSE, 2,  'M',  'M',         'DISPONIBIL', 1350.00, 1890.00, 'D2-AMP1'),
(11,2, 'BAR-NW-0011', FALSE, 4,  'M',  'M',         'DISPONIBIL', 420.00, 650.00, 'D2-CST1'),
(12,2, 'BAR-NW-0012', FALSE, 3,  'M',  'M',         'DISPONIBIL', 190.00, 299.00, 'D2-AMP2'),
(13, 5, 'BAR-NW-0013', FALSE, 3, 'M', 'M', 'DISPONIBIL', 120.00, 195.00, 'R2-M1'),
(14, 6, 'BAR-SH-0014', TRUE,  1, 'NM', 'VG+', 'DISPONIBIL', 220.00, 390.00, 'R2-M2'),
(15, 5, 'BAR-NW-0015', FALSE, 2, 'M', 'M', 'DISPONIBIL', 155.00, 250.00, 'R3-S1');

-- 14. Utilizatori (Notă: Utilizatorul 3 nu are încă nicio comandă)
INSERT INTO utilizator (nume_complet, email, parola_hash, telefon, rol, adresa_implicita) VALUES
('Mihai Ionescu', 'mihai.ionescu@mail.ro', '$2b$10$hashExempluClient1', '0740111222', 'CLIENT', 'Str. Victoriei nr. 14, Baia Mare'),
('Elena Radu', 'elena.radu@mail.ro', '$2b$10$hashExempluClient2', '0740333444', 'CLIENT', 'Str. Memorandumului nr. 8, Cluj-Napoca'),
('Vlad Mureșan', 'vlad.muresan@mail.ro', '$2b$10$hashExempluClient3', '0740555666', 'CLIENT', 'Bd. Unirii nr. 22, Baia Mare'),
('Cristian Pop', 'cristian.pop@musicstore.ro', '$2b$10$hashExempluOperator', '0740777888', 'OPERATOR_STOC', NULL),
('Admin Sistem', 'admin@musicstore.ro', '$2b$10$hashExempluAdmin', '0740999000', 'ADMIN', NULL);

-- 15. Comenzi
INSERT INTO comanda (id_utilizator, data_plasare, status_comanda, metoda_plata, adresa_livrare) VALUES
(1, '2026-11-05 14:20:00', 'FINALIZATA', 'CARD', 'Str. Victoriei nr. 14, Baia Mare'),
(2, '2026-11-10 18:05:00', 'EXPEDIATA', 'RAMBURS', 'Str. Memorandumului nr. 8, Cluj-Napoca'),
(1, '2026-11-18 11:30:00', 'PLASATA', 'TRANSFER', 'Str. Victoriei nr. 14, Baia Mare'),
(2, '2026-11-12 09:15:00', 'ANULATA', 'CARD', 'Str. Memorandumului nr. 8, Cluj-Napoca');

-- 16. Detalii comenzi (M:N; la comanda 2, căștile au un preț final promoțional de 620 față de 650)
INSERT INTO detalii_comanda (id_comanda, id_exemplar, cantitate_comandata, pret_vanzare_final) VALUES
(1, 3, 1, 185.00),
(1, 5, 1, 125.00),
(2, 11, 1, 620.00),
(2, 12, 1, 299.00),
(3, 8, 1, 265.00),
(3, 4, 2, 175.00),
(4, 6, 1, 195.00);