SELECT
    p.cod_sku,
    a.titlu_album,
    STRING_AGG(DISTINCT ar.nume_artist, ', ' ORDER BY ar.nume_artist) AS artisti,
    cd.nume_casa AS casa_discuri,
    em.format_fizic,
    em.an_editie,
    es.este_second_hand,
    es.grad_stare_media,
    es.pret_vanzare,
    es.cantitate_stoc
FROM exemplar_stoc es
JOIN produs p ON es.id_produs = p.id_produs
JOIN editie_muzicala em ON p.id_produs = em.id_produs
JOIN album a ON em.id_album = a.id_album
JOIN album_artist aa ON a.id_album = aa.id_album
JOIN artist ar ON aa.id_artist = ar.id_artist
JOIN casa_discuri cd ON em.id_casa_discuri = cd.id_casa_discuri
WHERE es.status_stoc = 'DISPONIBIL'
GROUP BY
    es.id_exemplar, p.cod_sku, a.titlu_album, cd.nume_casa,
    em.format_fizic, em.an_editie, es.este_second_hand,
    es.grad_stare_media, es.pret_vanzare, es.cantitate_stoc
ORDER BY a.titlu_album, es.pret_vanzare;

SELECT
    c1.nume_categorie AS categorie_sursa,
    e1.producator || ' ' || e1.model AS echipament_sursa,
    ct.tip_compatibilitate,
    c2.nume_categorie AS categorie_tinta,
    e2.producator || ' ' || e2.model AS echipament_tinta,
    ct.observatii_tehnice
FROM compatibilitate_tehnica ct
JOIN echipament_audio e1 ON ct.id_echipament_sursa = e1.id_produs
JOIN categorie_echipament c1 ON e1.id_categorie = c1.id_categorie
JOIN echipament_audio e2 ON ct.id_echipament_tinta = e2.id_produs
JOIN categorie_echipament c2 ON e2.id_categorie = c2.id_categorie
ORDER BY ct.tip_compatibilitate, echipament_sursa;


SELECT
    c.id_comanda,
    u.nume_complet AS client,
    c.data_plasare::DATE AS data_comenzii,
    c.status_comanda,
    SUM(dc.cantitate_comandata) AS total_articole,
    SUM(dc.cantitate_comandata * dc.pret_vanzare_final) AS total_comanda_ron,
    SUM(dc.cantitate_comandata * (dc.pret_vanzare_final - es.pret_achizitie)) AS marja_profit_ron
FROM comanda c
JOIN utilizator u ON c.id_utilizator = u.id_utilizator
JOIN detalii_comanda dc ON c.id_comanda = dc.id_comanda
JOIN exemplar_stoc es ON dc.id_exemplar = es.id_exemplar
WHERE c.status_comanda <> 'ANULATA'
GROUP BY c.id_comanda, u.nume_complet, c.data_plasare, c.status_comanda
ORDER BY total_comanda_ron DESC;


SELECT
    p.cod_sku,
    p.denumire_comerciala,
    p.tip_produs,
    COALESCE(SUM(CASE WHEN es.status_stoc = 'DISPONIBIL' THEN es.cantitate_stoc ELSE 0 END), 0) AS bucati_disponibile
FROM produs p
LEFT JOIN exemplar_stoc es ON p.id_produs = es.id_produs
GROUP BY p.id_produs, p.cod_sku, p.denumire_comerciala, p.tip_produs
HAVING COALESCE(SUM(CASE WHEN es.status_stoc = 'DISPONIBIL' THEN es.cantitate_stoc ELSE 0 END), 0) = 0
ORDER BY p.cod_sku;


SELECT
    a.titlu_album,
    a.gen_muzical,
    COUNT(pi.numar_ordine) AS numar_piese,
    COALESCE(SUM(pi.durata_secunde), 0) AS durata_secunde,
    CASE
        WHEN SUM(pi.durata_secunde) IS NULL THEN 'Fără tracklist'
        ELSE (SUM(pi.durata_secunde) / 60)::TEXT || ' min ' || (SUM(pi.durata_secunde) % 60)::TEXT || ' sec'
    END AS durata_formatata
FROM album a
LEFT JOIN piesa pi ON a.id_album = pi.id_album
GROUP BY a.id_album, a.titlu_album, a.gen_muzical
ORDER BY durata_secunde DESC;


SELECT
    f.nume_furnizor,
    f.tip_furnizor,
    COUNT(nr.id_receptie) AS numar_receptii,
    SUM(nr.total_valoare_intrare) AS total_achizitii_ron,
    MAX(nr.data_receptie) AS ultima_receptie
FROM furnizor f
JOIN nota_receptie nr ON f.id_furnizor = nr.id_furnizor
GROUP BY f.id_furnizor, f.nume_furnizor, f.tip_furnizor
HAVING SUM(nr.total_valoare_intrare) >= 500
ORDER BY total_achizitii_ron DESC;


SELECT
    p.denumire_comerciala,
    p.tip_produs,
    es.este_second_hand,
    es.grad_stare_media,
    es.pret_vanzare
FROM exemplar_stoc es
JOIN produs p ON es.id_produs = p.id_produs
WHERE es.status_stoc = 'DISPONIBIL'
  AND es.pret_vanzare > (
      SELECT AVG(es2.pret_vanzare)
      FROM exemplar_stoc es2
      JOIN produs p2 ON es2.id_produs = p2.id_produs
      WHERE p2.tip_produs = p.tip_produs
        AND es2.status_stoc = 'DISPONIBIL'
  )
ORDER BY p.tip_produs, es.pret_vanzare DESC;

SELECT
    u.nume_complet,
    u.email,
    COUNT(DISTINCT c.id_comanda) AS comenzi_valide,
    COALESCE(SUM(dc.cantitate_comandata * dc.pret_vanzare_final), 0.00) AS total_cheltuit_ron
FROM utilizator u
LEFT JOIN comanda c
    ON u.id_utilizator = c.id_utilizator
   AND c.status_comanda <> 'ANULATA'
LEFT JOIN detalii_comanda dc
    ON c.id_comanda = dc.id_comanda
WHERE u.rol = 'CLIENT'
GROUP BY u.id_utilizator, u.nume_complet, u.email
ORDER BY total_cheltuit_ron DESC;