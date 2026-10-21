# Sistem de Gestiune pentru magazin de muzică în format fizic și echipamente audio

## 1. Despre Proiect (About)
Acest proiect propune proiectarea și implementarea unui sistem informatic dedicat evidenței stocurilor, catalogării detaliate și vânzării de **muzică în format fizic** (viniluri, CD-uri, casete) și **echipamente audio aferente** (pickup-uri, amplificatoare, preamplificatoare phono, DAC-uri, căști, doze/ace și accesorii de întreținere).

### Motivația alegerii și particularități de proiectare
Spre deosebire de un magazin online generic, un magazin specializat pe suport fizic și echipamente Hi-Fi ridică trei probleme specifice de modelare a datelor:
1. **Ierarhia Muzicală (Album Master -> Ediție/Pressing -> Exemplar Fizic):** Separarea între opera muzicală (albumul lansat de un artist), ediția fizică specifică (ex: reeditare vinil 180g vs. ediție originală CD) și exemplarul fizic propriu-zis aflat în stoc (care pot fi *Nou/Sigilat* sau *Second-Hand/Vintage*, având o stare specifică a discului și a copertei - sitemul Goldmine: *Mint, Near Mint, Very Good+*).
2. **Eterogenitatea Produselor (Moștenire în BD relaționale):** Produsele împart atribute comune (cod SKU, preț, furnizor), dar au specificații tehnice complet diferite în funcție de categorie (viteză de rotație și casă de discuri pentru viniluri vs. impedanță, putere, tipuri de conectori RCA/DIN/XLR pentru echipamente).
3. **Compatibilitatea Tehnică Între Echipamente:** Modelarea relațiilor de compatibilitate între produse și componente (ex: ce doze/ace de schimb sunt compatibile cu un anumit braț de pickup)


## 2. Actorii Sistemului

* **Client/Vizitator:** Explorează catalogul, filtrează produsele după specificații muzicale sau tehnice, verifică compatibilitatea echipamentelor și plasează comenzi.
* **Gestionar Stoc (Operator):** Introduce ediții și echipamente noi în catalog, evaluează starea exemplarelor fizice (grading), recepționează marfa de la furnizori și procesează comenzile.
* **Administrator:** Gestionează conturile, furnizorii, categoriile tehnice și rapoartele de vânzări.

## 3. Arhitectura Paginilor Aplicației (Structura Interfeței)

Mai jos sunt descrise paginile principale (views) ale aplicației și corespondența lor cu operațiile din baza de date.


### Pagina 1: Catalog Muzică (Format Fizic)
* **Funcționalitate:** Afișarea și filtrarea albumelor disponibile după artist, gen muzical, format (Vinil LP, 7", CD, Casetă), casă de discuri, an de lansare și stare (Nou vs. Second-Hand).
* **Suport Bază de Date:** Interogări compleze cu JOIN între entitățile Artist, Album, Editie_Fizica și Exemplar_Stoc, utilizând indecși pe câmpurile de căutare frecventă.


### Pagina 2: Catalog Echipamente Audio & Accesorii
* **Funcționalitate:** Explorarea echipamentelor grupate pe categorii (Pickup-uri, Amplificatoare, DAC-uri, Căști, Doze, Accesorii) și filtrarea după parametri tehnici (ex: tip doză MM/MC, impedanță, tip tracțiune belt-drive/direct-drive).
* **Suport Bază de Date:** Interogarea structurii de tip Supratip/Subtip (Produs -> Echipament_Audio) și filtrarea după atribute tehnice normalizate.


### Pagina 3. Pagina de Detaliu Produs & Verificare Compatibilitate
* **Funcționalitate:**
    * Pentru *Muzică*: Afișează tracklist-ul, detaliile ediției și lista exemplarelor fizice disponibile în stoc cu gradul lor de uzură și preț individual.
    * Pentru *Echipamente*: Afișează specificațiile tehnice și o secțiune dinamică de **„Produse și piese compatibile”** (ex: doze compatibile cu pickup-ul selectat sau preamp-uri recomandate).
* **Suport Bază de Date:** Relație recursivă *Many-to-Many* în tabela Compatibilitate_Tehnica și agregarea datelor pe baza cheii primare a produsului.


### Pagina 4: Panou Gestiune Stoc & Grading (Back-Office)
* **Funcționalitate:** Formular intern pentru operatori prin care se adaugă în bazza de date fie o ediție/echipament nou în catalog, fie un exemplar fizic nou în inventar (cu asignarea stării fizice, a prețului de achiziție de la furnizor și a prețului de vânzare).
* **Suport Bază de Date:** Operații INSERT și UPDATE protejate prin constrângeri de integritate (CHECK pentru prețuri pozitive și coduri valide de grading, FOREIGN KEY către furnizori și catalog).


### Pagina 5: Coș de Cumpărături și Plasare Comandă
* **Funcționalitate:** Rezervarea exemplarelor selectate, introducerea datelor de livrare/facturare și finalizarea comenzii.
* **Suport Bază de Date:** Tranzacții ACID și declanșatoare (TRIGGERS) care verifică disponibilitatea stocului în timp real și marchează exemplarul fizic unic ca *Vândut/Rezervat* la confirmarea comenzii.
