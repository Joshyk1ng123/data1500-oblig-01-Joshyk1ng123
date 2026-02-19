-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

CREATE TABLE IF NOT EXIST kunde (
    kunde_id INT PRIMARY KEY AUTO_INCREMENT,
    fornavn Varchar(50) NOT NULL,
    etternavn VArchar(100) NOT NULL,
    mobilnr Varchar(20) CHECK (mobilnr IS NOT NULL OR mobilnr REGEXP '[0-9]'),  -- REGEXP '[0-9]' sier at d må minst være et siffer der
    epost Varchar(100) UNIQUE,  

    CHECK (epost IS NOT NULL OR epost like '%@%')
);

CREATE TABLE IF NOT EXIST sykkel (
    sykkel_id INT PRIMARY KEY AUTO_INCREMENT,
    sykkel_modell VArchar(50) NOT NULL,
    sykkel_innkjopsdato DATE NOT NULL   
);

CREATE TABLE IF NOT EXIST stasjon (
    stasjon_id INT PRIMARY KEY AUTO_INCREMENT,
    start_stasjon_navn Varchar(50) NOT NULL,
    slutt_stasjon_navn Varchar(50) NOT NULL,
    start_stasjon_adresse Varchar(100) NOT NULL,
    slutt_stasjon_adresse Varchar(100) NOT NULL

    

);

CREATE TABLE IF NOT EXIST utleierregistreringer (
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

-- =============================
-- 2️⃣ Sett inn testkunder (5 stk)
-- =============================

INSERT INTO kunde (fornavn, etternavn, mobilnr, epost) VALUES
('Ola', 'Nordmann', '12345678', 'ola@gmail.com'),
('Kari', 'Hansen', '87654321', 'kari@gmail.com'),
('Per', 'Johansen', '23456789', 'per@hotmail.com'),
('Anne', 'Larsen', '34567890', 'anne@yahoo.com'),
('Jon', 'Berg', '45678901', 'jon@gmail.com');

-- =============================
-- 3️⃣ Sett inn testsykler (100 stk)
-- =============================

-- Vi lager 100 sykler med enkel løkke i PostgreSQL
DO $$
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO sykkel (sykkel_modell, sykkel_innkjopsdato)
        VALUES ('Model ' || i, date '2024-01-01' + (i % 365));
    END LOOP;
END $$;

-- =============================
-- 4️⃣ Sett inn sykkelstasjoner (5 stk)
-- =============================

INSERT INTO stasjon (stasjon_navn, stasjon_adresse) VALUES
('Sentrum', 'Karl Johans gate 1'),
('Majorstuen', 'Bogstadveien 50'),
('Blindern', 'Problemveien 7'),
('Nydalen', 'Nydalsveien 15'),
('Grünerløkka', 'Markveien 25');

-- =============================
-- 5️⃣ Sett inn låser (20 per stasjon → 100 totalt)
-- =============================

DO $$
DECLARE
    st_id INT;
    i INT;
BEGIN
    FOR st_id IN SELECT stasjon_id FROM stasjon LOOP
        FOR i IN 1..20 LOOP
            INSERT INTO laas (stasjon_id, laas_nummer)
            VALUES (st_id, i);
        END LOOP;
    END LOOP;
END $$;

-- =============================
-- 6️⃣ Sett inn utleierregistreringer (50 stk)
-- =============================

-- Random utleierregistreringer fra eksisterende kunder, sykler og stasjoner
DO $$
DECLARE
    i INT;
    kunde_count INT := (SELECT COUNT(*) FROM kunde);
    sykkel_count INT := (SELECT COUNT(*) FROM sykkel);
    stasjon_count INT := (SELECT COUNT(*) FROM stasjon);
    start_ts INT;
    slutt_ts INT;
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO utleierregistreringer (
            kunde_id,
            sykkel_id,
            start_stasjon_id,
            slutt_stasjon_id,
            utleie_tidspunkt,
            innlevert_tidspunkt
        )
        VALUES (
            (SELECT kunde_id FROM kunde ORDER BY random() LIMIT 1),
            (SELECT sykkel_id FROM sykkel ORDER BY random() LIMIT 1),
            (SELECT stasjon_id FROM stasjon ORDER BY random() LIMIT 1),
            (SELECT stasjon_id FROM stasjon ORDER BY random() LIMIT 1),
            NOW() - (interval '1 day' * (random()*30)::int),
            NOW() - (interval '1 day' * (random()*30)::int) + interval '2 hours'
        );
    END LOOP;
END $$;

-- =============================
-- 7️⃣ Ferdig
-- =============================




-- DBA setninger (rolle: kunde, bruker: kunde_1)
CREATE ROLE admin_1 with LOGIN PASSWORD 'admin123'
CREATE ROLE kunde_1 with LOGIN PASSWORD 'kunde123'


-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;