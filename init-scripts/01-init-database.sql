-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

CREATE TABLE kunde (
    kunde_id INT PRIMARY KEY AUTO_INCREMENT,
    fornavn Varchar(50) NOT NULL,
    etternavn VArchar(100) NOT NULL,
    mobilnr Varchar(20) CHECK (mobilnr IS NOT NULL OR mobilnr REGEXP '[0-9]'), 
    epost Varchar(100) UNIQUE,  

    CHECK (epost IS NOT NULL OR epost like '%@%')
);

CREATE TABLE sykkel (
    sykkel_id INT PRIMARY KEY AUTO_INCREMENT,
    sykkel_modell VArchar(50) NOT NULL,
    sykkel_innkjopsdato DATE NOT NULL   
);

CREATE TABLE stasjon (
    stasjon_id INT PRIMARY KEY AUTO_INCREMENT,
    start_stasjon_navn Varchar(50) NOT NULL,
    slutt_stasjon_navn Varchar(50) NOT NULL,
    start_stasjon_adresse Varchar(100) NOT NULL,
    slutt_stasjon_adresse Varchar(100) NOT NULL

    

);

CREATE TABLE utleierregistreringer (
    utleie_id INT PRIMARY KEY AUTO_INCREMENT,
    kunde_id INT NOT NULL,
    sykkel_id INT NOT NULL,
    start_stasjon_id INT NOT NULL,
    slutt_stasjon_id INT NOT NULL,
    utleie_tidspunkt DATETIME NOT NULL,
    innlevert_tidspunkt DATETIME NOT NULL,

    FOREIGN KEY (kunde_id) REFERENCES kunde(kunde_id),
    FOREIGN KEY (sykkel_id) REFERENCES sykkel(sykkel_id),
    FOREIGN KEY (start_stasjon_id) REFERENCES stasjon(stasjon_id),
    FOREIGN KEY (slutt_stasjon_id) REFERENCES stasjon(stasjon_id),

    CHECK (utleie_tidspunkt < innlevert_tidspunkt)

);

-- Sett inn testdata



-- DBA setninger (rolle: kunde, bruker: kunde_1)



-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;