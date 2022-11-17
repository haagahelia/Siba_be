USE casedb;

DROP TABLE IF EXISTS AllocCurrentRoundUser;
DROP TABLE IF EXISTS AllocSpaceEquipment;
DROP TABLE IF EXISTS AllocSubjectSuitableSpace;
DROP TABLE IF EXISTS AllocSpace;
DROP TABLE IF EXISTS AllocSubject;
DROP TABLE IF EXISTS AllocRound;
DROP TABLE IF EXISTS SubjectEquipment;
DROP TABLE IF EXISTS `Subject`;
DROP TABLE IF EXISTS Program; 
DROP TABLE IF EXISTS SpaceEquipment;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS `Space`;
DROP TABLE IF EXISTS SpaceType;
DROP TABLE IF EXISTS Building;
DROP TABLE IF EXISTS DepartmentPlanner;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS Department; 
DROP TABLE IF EXISTS GlobalSetting;


/* ------------------------------------------------------ */


/* --- 01 CREATE TABLES --- */

USE casedb;

/* --- 01 CREATE TABLES --- */

CREATE TABLE IF NOT EXISTS GlobalSetting (
    id          INTEGER        NOT NULL AUTO_INCREMENT,
    name        VARCHAR(255)   UNIQUE NOT NULL,
    description VARCHAR(16000),
    numberValue INTEGER,
    textValue   VARCHAR(255),
    
    PRIMARY KEY (id)
)   ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS Department (
    id          INTEGER         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(255)    UNIQUE NOT NULL,
    description VARCHAR(16000)  ,

    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `User` (
    id          INTEGER         NOT NULL AUTO_INCREMENT,
    email       VARCHAR(255)    UNIQUE NOT NULL,
    isAdmin     BOOLEAN         NOT NULL DEFAULT 0,

    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS DepartmentPlanner (
    departmentId    INTEGER     NOT NULL,
    userId          INTEGER     NOT NULL,

    PRIMARY KEY (departmentId, userId),

    CONSTRAINT FOREIGN KEY (departmentId) REFERENCES Department(id) 
        ON DELETE CASCADE 
        ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (userId) REFERENCES `User`(id) 
        ON DELETE CASCADE 
        ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS Building (
    id          INTEGER         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(255)    UNIQUE NOT NULL,
    description VARCHAR(16000), 

    PRIMARY KEY (id)

) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS SpaceType (
    id      INTEGER NOT NULL AUTO_INCREMENT,
    name    VARCHAR(255) NOT NULL,
    description VARCHAR(16000),

    PRIMARY KEY(id)

) ENGINE=InnoDB AUTO_INCREMENT=5001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Space` (
    id              INTEGER NOT NULL AUTO_INCREMENT,
    name            VARCHAR(255) NOT NULL,
    area            DECIMAL(5,1),
    info            VARCHAR(16000),
    personLimit     INTEGER,
    buildingId      INTEGER NOT NULL,
    availableFrom   TIME,
    availableTo     TIME,
    classesFrom     TIME,
    classesTo       TIME,
	inUse			BOOLEAN DEFAULT 1,
    spaceTypeId     INTEGER,

    CONSTRAINT AK_UNIQUE_name_in_building UNIQUE(buildingId, name),

    PRIMARY KEY (id),

    CONSTRAINT `FK_space_building`
    	FOREIGN KEY (`buildingId`) REFERENCES `Building`(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    
    CONSTRAINT `FK_space_spaceType`
    	FOREIGN KEY (`spaceTypeId`) REFERENCES `SpaceType`(id)
            ON DELETE SET NULL
            ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS Equipment (
    id            INTEGER             NOT NULL AUTO_INCREMENT,
    name          VARCHAR(255)        UNIQUE NOT NULL,
    isMovable     BOOLEAN             NOT NULL,
    priority      INTEGER             NOT NULL DEFAULT 0,
    description   VARCHAR(16000),

    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=2001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS SpaceEquipment (
    spaceId       INTEGER     NOT NULL,
    equipmentId   INTEGER     NOT NULL,
    
    PRIMARY KEY(spaceId,equipmentId),

    CONSTRAINT `FK_SpaceEquipment_Equipment` 
        FOREIGN KEY (`equipmentId`) REFERENCES `Equipment` (id) 
            ON DELETE CASCADE 
            ON UPDATE CASCADE,
    CONSTRAINT `FK_SpaceEquipment_Space` 
        FOREIGN KEY (`spaceId`) REFERENCES `Space` (id) 
            ON DELETE CASCADE 
            ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS Program (
  id            INTEGER         NOT NULL AUTO_INCREMENT,
  name          VARCHAR(255)    NOT NULL UNIQUE,
  
  departmentId  INTEGER         NOT NULL,

  PRIMARY KEY (id),
  
  CONSTRAINT FOREIGN KEY (departmentId) REFERENCES Department(id) 
    ON DELETE NO ACTION       
    ON UPDATE NO ACTION       
) ENGINE=InnoDB AUTO_INCREMENT=3001 DEFAULT CHARSET=latin1;

-- Tarvitaanko Program-taulussa tätä:
-- participants INT(4),

CREATE TABLE IF NOT EXISTS `Subject` (
    id              INTEGER         NOT NULL AUTO_INCREMENT,
    name            VARCHAR(255)    UNIQUE,
    groupSize       INTEGER,
    groupCount      INTEGER,
    sessionLength   TIME,
    sessionCount    INTEGER,
    area            DECIMAL(5,1) DEFAULT NULL,         
    programId       INTEGER NOT NULL,
    spaceTypeId     INTEGER,

    CONSTRAINT AK_Subject_unique_name_in_program UNIQUE (programId, name),
  
    PRIMARY KEY (id),

    CONSTRAINT `FK_Subject_Program` FOREIGN KEY (`programId`) 
        REFERENCES `Program`(id) 
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,

    CONSTRAINT `FK_Subject_SpaceType` FOREIGN KEY (`SpaceTypeId`)
        REFERENCES `SpaceType`(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS SubjectEquipment (
    subjectId      INTEGER     NOT NULL,
    equipmentId    INTEGER     NOT NULL,
    priority       INTEGER     NOT NULL,
    obligatory     BOOLEAN     DEFAULT 0,

    PRIMARY KEY (subjectId, equipmentId),

    CONSTRAINT `FK_SubjectEquipment_Subject` FOREIGN KEY (`subjectId`) REFERENCES `Subject`(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT `FK_SubjectEquipment_Equipment` FOREIGN KEY (`equipmentId`) REFERENCES `Equipment`(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/* CREATE ALLOC TABLES */

CREATE TABLE IF NOT EXISTS AllocRound (
    id              INTEGER     NOT NULL AUTO_INCREMENT,
    date            TIMESTAMP   NOT NULL DEFAULT current_timestamp(),
    name            VARCHAR(255) NOT NULL,
    isSeasonAlloc   BOOLEAN,
    userId          INTEGER     NOT NULL,
    description     VARCHAR(16000),
    lastModified    TIMESTAMP   NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),

    PRIMARY KEY(id),
    
    CONSTRAINT `FK_AllocRound_User` FOREIGN KEY (`userId`)
        REFERENCES `User`(id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE

)ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS AllocSubject (
    subjectId       INTEGER     NOT NULL,
    allocRound      INTEGER     NOT NULL,
    isAllocated     BOOLEAN     DEFAULT 0,
    cantAllocate    BOOLEAN     DEFAULT 0,
    priority        INTEGER,
    allocatedDate   TIMESTAMP, 
    
    PRIMARY KEY(subjectId, allocRound), 

    CONSTRAINT `FK_AllocSubject_Subject` FOREIGN KEY (`subjectId`)
        REFERENCES `Subject`(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT `FK_AllocSubject_AllocRound` FOREIGN KEY (`allocRound`)
        REFERENCES `AllocRound`(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE  
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE IF NOT EXISTS AllocSpace (
    subjectId       INTEGER     NOT NULL,
    allocRound      INTEGER     NOT NULL,
    spaceId         INTEGER     NOT NULL,
    totalTime       TIME,

    PRIMARY KEY(subjectId, allocRound, spaceId),

    CONSTRAINT `FK_AllocSpace_AllocSubject`
        FOREIGN KEY (`subjectId`, `allocRound`)
        REFERENCES `AllocSubject` (subjectId, allocRound)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT `FK_AllocSpace_Space`
        FOREIGN KEY (`spaceId`)
        REFERENCES `Space` (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS AllocSubjectSuitableSpace (
    allocRound      INTEGER     NOT NULL,
    subjectId       INTEGER     NOT NULL,
    spaceId         INTEGER     NOT NULL,
    missingItems    INTEGER,

    PRIMARY KEY(allocRound, subjectId, spaceId),

    CONSTRAINT `FK_AllocSubjectSpace_AllocSubject`
        FOREIGN KEY(`allocRound`, `subjectId`)
        REFERENCES `AllocSubject` (allocRound, subjectId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT `FK_AllocSubjectSpace_Space`
        FOREIGN KEY (`spaceId`)
        REFERENCES `Space` (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS AllocCurrentRoundUser (
    allocId     INTEGER     NOT NULL,
    userId      INTEGER,
    
    PRIMARY KEY(allocId, userId),
    
    CONSTRAINT `FK_AllocCurrentRoundUser_AllocRound` 
        FOREIGN KEY (`allocId`) 
        REFERENCES `AllocRound` (id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
        
    CONSTRAINT `FK_AllocCurrentRoundUser_User` 
        FOREIGN KEY (`userId`) 
        REFERENCES `User` (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* ------------------------------------------------------ */

/* INSERTS */
USE casedb;

/* INSERTS */
/* --- Insert: GlobalSettings --- */
INSERT INTO GlobalSetting(name, description, numberValue, textValue) VALUES
    ('X', 'Korkea prioriteettiarvo', 800, NULL);

/* --- Insert: Department --- */
INSERT INTO Department(name, description) VALUES
	('Jazz', 'Aineryhmän kuvaus'),
    ('Laulumusiikki', 'Aineryhmän kuvaus'),
    ('Piano, harmonikka, kitara ja kantele', 'Aineryhmän kuvaus'),
    ('Musiikkikasvatus', 'Aineryhmän kuvaus'),
    ('MuTri', 'Aineryhmän kuvaus'),
    ('Vanha musiikki', 'Aineryhmän kuvaus'),
    ('Musiikkiteknologia', 'Aineryhmän kuvaus'),
    ('Musiikinjohtaminen sekä orkesteri- ja kuorotoiminta', 'Aineryhmän kuvaus'),
    ('Taidejohtaminen ja yrittäjyys', 'Aineryhmän kuvaus'),
    ('DocMus', 'Tohtoritason koulutusohjelma'),
    ('Kansanmusiikki ja Global music & GLOMAS', 'Aineryhmän kuvaus'),
    ('Kirkkomusiikki ja urut', 'Aineryhmän kuvaus'),
    ('Jouset ja kamarimusiikki', 'Aineryhmän kuvaus'),
    ('Puhaltimet, lyömäsoittimet ja harppu', 'Aineryhmän kuvaus'),
    ('Sävellys ja musiikinteoria', 'Aineryhmän kuvaus'),
    ('Avoin Kampus', 'Aineryhmän kuvaus');

/* --- Insert: `User` --- */
INSERT INTO `User`(email, isAdmin) VALUES
    ('fake_admin@test.co', 1),
    ('fake_planner@test.co', 0),
    ('fake_planner2@test.co', 0);

/* --- Insert: DepartmentPlanner * --- */
INSERT INTO DepartmentPlanner(userId, departmentId) VALUES
    (202, 101),
    (202, 105),
    (203, 103),
    (203, 104),
    (202, 102);

    
/* --- Insert: Building * --- */
INSERT INTO `Building` (`name`, `description`) VALUES
	('Musiikkitalo', 'Sibeliusakatemian päärakennus'),
	('N-talo', 'Sibeliusakatemian opetus ja harjoittelu talo '),
	('R-talo', 'Sibeliusakatemian konserttitalo');

/* --- Insert: SpaceType --- */
INSERT INTO SpaceType (name) VALUES
    ('Studio'),
    ('Luentoluokka'),
    ('Esitystila'),
    ('Musiikkiluokka');

/* --- Insert: `Space` * --- */
INSERT INTO `Space` (`name`, `area`, `personLimit`, `buildingId`, `availableFrom`, `availableTo`, `classesFrom`, `classesTo`, `info`, `spaceTypeId`) VALUES
	('S6117 Jouset/Kontrabasso', 31.9, 7, 401, '08:00:00', '21:00:00', '09:00:00', '16:00:00', 'ONLY FOR BASSISTS', 5004),
	('S6104 Didaktiikkaluokka Inkeri', 62.5, 30, 401, '08:00:00', '21:00:00', '10:00:00', '17:00:00', 'Musiikkikasvatus', 5004),
	('S7106 Kansanmusiikki/AOV', 63.7, 22, 401, '08:00:00', '21:00:00', '08:00:00', '18:00:00', 'Yhtyeluokka', 5004), 
    ('S6114 Perkussioluokka/Marimbaluokka', 33.3, 4, 401, '08:00:00', '22:00:00', '09:00:00', '15:00:00', 'Vain lyömäsoittajat', 5004),
    ('S1111 Studio Erkki', 36.0, 15, 401, '08:00:00', '22:00:00', '11:00:00', '15:00:00', 'Tilatyyppi: Studio', 5001),
    ('S5109 Jazz/Bändiluokka', 17.5, 2, 401, '08:00:00', '20:00:00', '08:00:00', '16:00:00', 'ONLY FOR JAZZ DEPARTMENT', 5004),
    ('S6112 Harppuluokka', 28.8, 4, 401, '08:00:00', '17:00:00', '11:00:00', '16:00:00', 'Vain harpistit', 5004),
    ('S6113 Puhaltimet/Klarinetti/Harppu', 18.1, 4, 401, '08:00:00', '19:00:00', '08:00:00', '19:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    
    ('R312 Opetusluokka', 16.6, 6, 403, '08:00:00', '21:00:00', '08:00:00', '18:00:00', 'Tilatyyppi: Musiikkiluokka', 5004), 
    ('R530 Opetusluokka', 50.0, 18, 403, '08:00:00', '21:00:00', '08:00:00', '19:00:00', 'Luentoluokka', 5002),
    ('R213 Harjoitushuone', 20.0, 4, 403, '08:00:00', '21:00:00', '10:00:00', '16:00:00', 'Ensisijainen varausoikeus vanhan musiikin aineryhmällä', 5004),
    ('R510 Opetusluokka', 81.0, 30, 403, '08:00:00', '21:00:00', '09:00:00', '15:00:00', 'Luentoluokka', 5002),
    ('R416 Opetusluokka', 23.0, 9, 403, '08:00:00', '21:00:00', '10:00:00', '17:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('R422 Opetusluokka', 23.0, 11, 403, '08:00:00', '19:00:00', '08:00:00', '22:00:00', 'Kitara', 5004),
    ('R410 Opetusluokka', 42.4, 20, 403, '08:00:00', '19:00:00', '08:00:00', '20:00:00', 'Pianopedagogiikka', 5004),
    ('R531 Opetusluokka', 53.0, 17, 403, '09:00:00', '20:00:00', '10:00:00', '14:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),

    ('N522 Säestysluokka', 33.0, 8, 402, '08:00:00', '21:00:00', '08:00:00', '19:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N319 Jazz/Lyomäsoittimet, piano ja yhtyeet', 34.0, 5, 402, '08:00:00', '19:00:00', '08:00:00', '17:00:00', 'Varaukset Jukkis Uotilan kautta', 5004),
    ('N315 Jouset', 15.5, 4, 402, '08:00:00', '21:00:00', '08:00:00', '14:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N419 Kirkkomusiikki/Urkuluokka', 34.0, 5, 402, '09:00:00', '20:00:00', '08:00:00', '18:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N517 Opetusluokka', 15.5, 3, 402, '08:00:00', '21:00:00', '08:00:00', '15:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N425 Jouset/Sello', 33.0, 8, 402, '08:00:00', '22:00:00', '09:00:00', '15:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N312 Musiikkikasvatus/Vapaasäestys', 34.0, 8, 402, '08:00:00', '22:00:00', '08:00:00', '15:00:00', 'Tilatyyppi: Musiikkiluokka', 5004),
    ('N220 Tohtorikoulut', 49.5, 20, 402, '08:00:00', '19:00:00', '08:00:00', '17:00:00', 'Tilatyyppi: Luentoluokka', 5002);


/* --- Insert: Equipment --- */
INSERT INTO `Equipment` (`name`, `isMovable`, `priority`, `description`) VALUES
	('Urut', 0, 600, 'Valtavan kokoinen soitin'),
	('Kantele', 1, 50, 'Väinämöisen soitin'),
    ('Nokkahuilu', 1, 50, 'Kaikki rakastaa'),
    ('Rumpusetti', 1, 250, 'Ääntä riittää'),
    ('Äänityslaitteisto Xyz', 0, 900, '8 kanavaa'),
    ('Viulu', 1, 50, 'Jousisoitin, 4-kieltä'),
    ('Alttoviulu', 1, 50, 'Jousisoitin, suurempi kuin viulu'),
    ('Sello', 1, 100, 'Suuri, 4-kielinen jousisoitin'),
    ('Kontrabasso', 1, 100, 'Suurin jousisoitin'),
    ('Piano', 0, 900, 'Piano-opetus vaatii kaksi flyygeliä'),
    ('Kitara', 1, 100, '6-kielinen soitin'),
    ('Harmonikka', 1, 200, 'Hanuri'),
    ('Fortepiano', 0, 500, 'Pianon varhaismuoto'),
    ('Huilu', 1, 50, 'puhallinsoitin'),
    ('Oboe', 1, 100, 'puupuhallinsoitin'),
    ('Tuuba', 1, 100, 'Suurehko puhallinsoitin'),
    ('Trumpetti', 1, 50, 'Puhallinsoitin'),
    ('Clavinova', 1, 100, 'Sähköpiano'),
    ('Bassovahvistin', 1, 50, 'Boom boom'),
    ('Kitaravahvistin', 1, 50, 'Äänekäs laatikko'),
    ('Flyygeli', 1, 200, ''),
    ('DVD-soitin', 1, 50, ''),
    ('Äänentoisto (ei PA-laitteet)', 0, 100, ''),
    ('Näyttölaite (videoprojektori)', 0, 200, ''),
    ('Yhtyeluokan äänentoisto', 0, 300, 'PA-laitteet'),
    ('Dokumenttikamera', 0, 250, ''), 
    ('Sähkökitara', 1, 100, 'Sähkökitara');
    
/* --- Insert: SpaceEquipment * --- */
INSERT INTO `SpaceEquipment` (`spaceId`, `equipmentId`) VALUES
	(1001, 2021),
    (1001, 2022),
    (1001, 2023),
    (1001, 2024),
	(1002, 2021),
    (1002, 2004),
    (1002, 2019),
    (1002, 2020),
    (1002, 2022),
    (1002, 2023),
    (1002, 2025),
    (1002, 2024),
    (1002, 2026),
	(1009, 2010),
    (1009, 2021),
    (1009, 2023),
    (1013, 2021),
    (1013, 2023),
    (1020, 2001),
    (1020, 2022),
    (1020, 2023),
    (1020, 2024),
    (1019, 2021),
    (1019, 2022),
    (1019, 2023),
    (1019, 2024),
    (1005, 2010),
    (1005, 2004),
    (1006, 2004),
    (1003, 2004),
    (1004, 2004),
    (1018, 2004),
    (1014, 2011),
    (1006, 2011),
    (1018, 2010),
    (1013, 2010);
    
/* --- Insert: Program * --- */
INSERT INTO Program (name , departmentId) VALUES
    ('Piano', 103), -- id 3001
    ('Laulutaide pääaineena', 102),
    ('Kitara', 103),
    ('Kantele', 103),
    ('Jazzsävellys', 101),
    ('Musiikinteoria pääaineena', 104), 
    ('Jazzmusiikin instrumentti- tai lauluopinnot pääaineena', 102),
    ('Fortepiano', 103),
    ('Global Music', 112),
    ('Harmonikka', 103),
    ('Harppu', 114),
    ('Jousisoitin', 113),
    ('Kansanmusiikki', 111),
    ('Kirkkomusiikki', 112),
    ('Korrepetitio', 102),
    ('Lyömäsoitin', 114),
    ('Musiikin johtaminen', 108), -- ei löydy kurseja
    ('Musiikin tohtorikoulutus', 110),
    ('Musiikkikasvatus', 104),
    ('Musiikkiteknologia', 107),
    ('Nordic Master in Folk Music', 111),
    ('Nordic Master in Jazz', 101),
    ('Oopperalaulu', 102),
    ('Pianokamarimusiikki ja lied', 103),
    ('Puhallinsoitin', 114),
    ('Sävellys', 115),
    ('Taidejohtaminen ja yrittäjyys', 109),
    ('Urut', 112),
    ('Vanha musiikki', 106),
    ('Avoin Kampus', 110); 

/* --- Insert: Subject * --- */
INSERT INTO Subject(name, groupSize, groupCount, sessionLength, sessionCount, area, programId, spaceTypeId) VALUES
    ('Saksan kielen perusteet', 20, 2, '01:30:00', 2, 35, 3030, 5002), 
    ('Jazzimprovisoinnin ja -teorian perusteet', 17, 1, '02:30:00', 2, 35, 3005, 5004),
    ('Piano yksilöopetus', 1, 1, '02:30:00', 2, 10, 3001, 5004),
    ('Trumpetin ryhmäsoitto', 10, 1,'01:30:00', 3, 40, 3025, 5004),
    ('Kirkkomusiikin ryhmäsoittoa', 5, 2, '02:30:00', 2, 30, 3014, 5004),
    ('Ruotsin kielen oppitunti', 18, 2, '01:45:00', 1, 25, 3030, 5002),
    ('Kitaran soiton perusteet', 11, 1, '01:30:00', 2, 25, 3003, 5004),
    ('Kontrabassonsoitto, taso A', 1, 3, '01:00:00', 2, 10, 3012, 5004),
    ('Kanteleensoitto (musiikin kandidaatti)', 1, 4, '01:00:00', 1, 10, 3004, 5004),
    ('Yhteissoitto / kantele', 16, 1, '01:30:00', 1, 20, 3004, 5004),
    ('Urkujensoitto (musiikin kandidaatti)', 1, 3, '01:30:00', 1, 20, 3028, 5004),
    ('Yhteissoitto / kitara', 34, 1, '01:30:00', 1, 35, 3003, 5004),
    ('Huilunsoitto, taso A', 1, 5, '01:00:00', 1, 10, 3025, 5004),
    ('Fortepianonsoitto 1', 1, 7, '01:10:00', 2, 30, 3008, 5004),
    ('Nokkahuilunsoitto, taso B', 1, 3, '01:00:00', 1, 10, 3025, 5004),
    ('Viulunsoitto, taso D', 1, 12, '01:00:00', 1, 10, 3012, 5004),
    ('Tuubansoitto, taso C', 1, 5, '01:00:00', 1, 15, 3025, 5004),
    ('Harmonikansoitto (musiikin kandidaatti)', 1, 2, '01:00:00', 1, 15, 3010, 5004),
    ('Jazz, rumpujensoitto, taso B', 1, 4, '01:00:00', 1, 15, 3016, 5004),
    ('Kansanmusiikkiteoria 1', 20, 1, '01:00:00', 2, 30, 3013, 5002),
    ('Kirkkomusiikin käytännöt 1', 20, 1, '03:00:00', 1, 30, 3014, 5002),
    ('Nuottikirjoitus', 15, 1, '02:00:00', 1, 25, 3030, 5002),
    ('Harpun orkesterikirjallisuus', 15, 1, '03:00:00', 1, 25, 3011, 5002),
    ('Global Orchestra', 12, 2, '02:30:00', 2, 35, 3009, 5004),
    ('Populaarimusiikin historia', 20, 1, '03:00:00', 1, 30, 3019, 5002),
    ('Oppimaan oppiminen', 15, 2, '02:30:00', 1, 25, 3030, 5002),
    ('Body Mapping', 25, 2, '02:30:00', 2, 35, 3030, 5002),
    ('Muusikon Terveys', 20, 1, '02:30:00', 1, 30, 3030, 5002),
    ('Pianomusiikin historia', 18, 1, '01:00:00', 1, 30, 3001, 5002),
    ('Syventävä ensemblelaulu', 4, 3, '00:45:00', 1, 10, 3002, 5004),
    ('Laulu, pääinstrumentti', 1, 10, '01:00:00', 1, 5, 3002, 5004),
    ('The jazz line - melodisen jazzimprovisoinnin syventävät opinnot', 14, 1, '02:00:00', 1, 20, 3005, 5002),
    ('Jazzensemble', 5, 1, '02:00:00', 1, 20, 3007, 5004),
    ('Äänenkäyttö ja huolto / korrepetitiokoulutus', 4, 3, '01:00:00', 1, 10, 3015, 5004),
    ('Prima vista / korrepetitiokoulutus', 2, 6, '01:00:00', 1, 15, 3015, 5004),
    ('Musiikinhistorian lukupiiri', 10, 1, '01:00:00', 1 , 15, 3019, 5002),
    ('Tohtoriseminaari (sävellys)', 17, 1, '02:00:00', 1, 30, 3019, 5002),
    ('Musiikkiteknologian perusteet', 15, 1, '01:00:00', 1, 30, 3020, 5004),
    ('Johtamisen pedagogiikka -luentosarja', 10, 1, '02:00:00', 1, 20, 3018, 5002);


/* --- Insert: SubjectEquipment * --- */
INSERT INTO SubjectEquipment(subjectId, equipmentId, priority) VALUES
    (4003, 2021, 900),
    (4004, 2017, 50),
    (4005, 2001, 900),
    (4007, 2011, 100),
    (4008, 2009, 90),
    (4009, 2002, 50),
    (4010, 2002, 90),
    (4011, 2001, 900),
    (4012, 2011, 90),
    (4013, 2012, 50),
    (4014, 2013, 900),
    (4015, 2003, 50),
    (4016, 2006, 90),
    (4017, 2016, 90),
    (4018, 2012, 90),
    (4019, 2014, 800),
    (4020, 2010, 400),
    (4003, 2010, 700),
    (4005, 2010, 500),
    (4014, 2010, 500),
    (4031, 2010, 500),
    (4024, 2010, 500),
    (4002, 2011, 400),
    (4024, 2011, 500),
    (4033, 2011, 500),
    (4019, 2004, 700),
    (4005, 2004, 600),
    (4024, 2004, 600),
    (4033, 2004, 600);

/* --- Insert: AllocRound * --- */
INSERT INTO AllocRound(name, isSeasonAlloc, userId, description) VALUES
    ('Testipriorisointi', 0, 201, 'Testidata lisätään AllocSubject tauluun, mutta laskentaa ei vielä suoritettu eli opetuksille ei ole vielä merkitty tiloja'),
    ('Testilaskenta', 1, 201, 'Testidata lisätty ja huoneet merkitty'),
    ('Kevät 2023', 0, 201, '');

/* --- Insert: AllocSubject * --- */
INSERT INTO AllocSubject(subjectId, allocRound, isAllocated, allocatedDate, priority) VALUES
    (4011, 10001, 0, '2022-10-28', 1),
    (4014, 10001, 0, '2022-10-28', 2),
    (4019, 10001, 0, '2022-10-28', 3),
    (4013, 10001, 0, '2022-10-28', 4),
    (4001, 10001, 0, '2022-10-28', 5),

    (4011, 10002, 1, '2022-10-28', 1), -- Urkujensoitto, 1ppl, 1:30/4:30, 20m2, musiikkiluokka
    (4003, 10002, 1, '2022-10-28', 2), -- Piano yksilöopetus, 1ppl, 2:30/05:00, 10m2, musiikkiluokka
    (4005, 10002, 1, '2022-10-28', 3), -- Kirkkomusiikin ryhmäsoitto, 5ppl, 2:30/10:00, musiikkiluokka
    (4024, 10002, 1, '2022-10-28', 4), -- Global Orchestra, 12ppl, 2:30/10:00, 35m2, musiikkiluokka
    (4004, 10002, 1, '2022-10-28', 5), -- Trumpetin ryhmäsoitto, 10ppl, 1:30/4:30, 40m2 
    (4014, 10002, 1, '2022-10-28', 6), -- fortepianosoitto, 1ppl, 16:20, 30m2, musiikkiluokka, 
    (4019, 10002, 1, '2022-10-28', 7), -- jazz rummut, 1ppl, 4:00, 15m2, musiikkiluokka
    (4013, 10002, 1, '2022-10-28', 8), -- huilujensoitto taso a, 1ppl, 05:00, 10m2, musiikkiluokka
    (4002, 10002, 1, '2022-10-28', 9), -- jazz improvisoinnin perusteet, 17ppl, 2:30/5:00, 35m2, musiikkiluokka
    (4016, 10002, 1, '2022-10-28', 10), -- Viulunsoitto taso D, 1ppl, 01:00/12:00, 10m2, musiikkiluokka
    (4017, 10002, 1, '2022-10-28', 11), -- Tuubansoitto Taso C, 1ppl, 01:00/05:00, 15m2, musiikkiluokka
    (4008, 10002, 1, '2022-10-28', 12), -- Kontrabassonsoitto Taso A, 1ppl, 01:00/06:00, 10m2, musiikkiluokka
    (4007, 10002, 1, '2022-10-28', 13), -- Kitaran soiton perusteet, 11ppl, 1:30/03:00, 60m2, musiikkiluokka
    (4023, 10002, 1, '2022-10-28', 14), -- Harpun orkesterikirjallisuus, 15ppl, 3:00, 25m2, teorialuokka
    (4020, 10002, 1, '2022-10-28', 15), -- Kansanmusiikkiteoria 1, 20ppl, 1:00/2:00, 30m2, teorialuokka
    (4027, 10002, 1, '2022-10-28', 16), -- Body mapping, 20, 2:30, 30m2, teorialuokka
    (4028, 10002, 1, '2022-10-28', 17), -- Muusikon terveys, 20ppl, 2:30, 30m2, teorialuokka
    (4021, 10002, 1, '2022-10-28', 18), -- Kirkkomusiikin käytännöt, 20ppl, 03:00, 30m2, teorialuokka
    (4022, 10002, 1, '2022-10-28', 19), -- Nuottikirjoitus, 15ppl, 2:00, 25m2, teorialuokka
    (4001, 10002, 1, '2022-10-28', 20), -- saksan kielen perusteet, 10ppl, 06:00, 35m2, teorialuokka
    (4006, 10002, 1, '2022-10-28', 21), -- Ruotsin kielen oppintunti, 40ppl, 1:45/3:30, 40m2, teorialuokka
    (4018, 10002, 1, '2022-10-28', 22), -- Harmonikansoitto, 1ppl, 01:00/02:00, 15m2, musiikkiluokka
    (4029, 10002, 1, '2022-10-28', 23), -- pianomusiikin historia, 24ppl, 01:00, 30m2, teorialuokka
    (4030, 10002, 1, '2022-10-28', 24), -- Syventävä ensemblelaulu, 4ppl, 00:45/01:45, 10m2, musiikkiluokka
    (4031, 10002, 1, '2022-10-28', 25), -- Laulu, pääinstrumentti, 1ppl, 01:00/10:00, 5m2, musiikkiluokka
    (4009, 10002, 1, '2022-10-28', 26), -- kanteleensoitto, 1ppl, 01:00/04:00, 10m2, musiikkiluokka
    (4032, 10002, 1, '2022-10-28', 27), -- the jazz line, 14ppl, 02:00, 20m2, musiikkiluokka
    (4033, 10002, 1, '2022-10-28', 28), -- Jazzensemble, 5ppl, 02:00, 20m2, musiikkiluokka
    (4034, 10002, 1, '2022-10-28', 29), -- Äänenkäyttö ja huolto / korrepetitiokoulutus, 
    (4035, 10002, 1, '2022-10-28', 30), -- Prima vista / korrepetitiokoulutus
    (4036, 10002, 1, '2022-10-28', 31), -- Musiikinhistorian lukupiiri
    (4037, 10002, 1, '2022-10-28', 32), -- Tohtoriseminaari (sävellys)
    (4038, 10002, 1, '2022-10-28', 33), -- Musiikkiteknologian perusteet
    (4039, 10002, 1, '2022-10-28', 34), -- Johtamisen pedagogiikka -luentosarja

    (4001, 10003, 0, '2022-09-21', 1),  
    (4002, 10003, 0, '2022-09-21', 2),
    (4003, 10003, 0, '2022-09-21', 3),
    (4004, 10003, 0, '2022-09-21', 4),
    (4005, 10003, 0, '2022-09-21', 5),
    (4006, 10003, 0, '2022-09-21', 6),
    (4007, 10003, 0, '2022-09-21', 7);

INSERT INTO AllocSpace(subjectId, allocRound, spaceId, totalTime) VALUES
    (4011, 10002, 1020, '04:30:00'), -- Urkujensoitto 1ppl/ N419 urkuluokka, 34m2, 5ppl
    (4003, 10002, 1009, '05:00:00'), -- Pianon yksilöopetus 1ppl/ musiikkiluokka 16.6m2, 6ppl
    (4005, 10002, 1020, '10:00:00'), -- Kirkkomusiikin ryhmäsoitto 5ppl/ N419 Kirkkomusiikki, 34m2, 5ppl
    (4024, 10002, 1016, '10:00:00'), -- Global Orchestra 12ppl/ musiikkiluokka 53m2, 17ppl
    (4004, 10002, 1016, '04:30:00'), -- Trumpetin ryhmäsoitto 10ppl/ R531 Musiikkiluokka, 33m2, 8ppl
    (4014, 10002, 1009, '16:20:00'), -- Fortepianonsoitto 1ppl/ R312 Musiikkiluokka, 16.6m2, 6ppl
    (4019, 10002, 1018, '04:00:00'), -- Jazz rummut 1ppl/ S6114 Perkussioluokka, 33.3m2, 4ppl
    (4013, 10002, 1009, '05:00:00'), -- Huilujensoitto taso A 1ppl/ R312 Musiikkiluokka, 16.6m2, 6ppl
    (4002, 10002, 1016, '05:00:00'), -- Jazz improvisoinnin perusteet 17ppl/ R531 Musiikkiluokka, 53m2, 17ppl
    (4016, 10002, 1009, '12:00:00'), -- Viulunsoitto taso D 1ppl/ R312 Musiikkiluokka, 16.6m2, 6ppl
    (4017, 10002, 1009, '05:00:00'), -- Tuubansoitto taso C 1ppl/ R312 Musiikkiluokka, 16.6m2, 6ppl
    (4008, 10002, 1009, '06:00:00'), -- Kontrabassonsoitto taso A 1ppl/ R313 Musiikkiluokka, 16.6m2, 6ppl
    (4007, 10002, 1016, '03:00:00'), -- Kitaran soiton perusteet 11ppl/ R422 Opetusluokka (Kitara), 23m2, 11ppl
    (4023, 10002, 1010, '03:00:00'), -- Harpun orkesterikirjallisuus 15ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4020, 10002, 1010, '02:00:00'), -- Kansanmusiikinteoria 1 20ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4027, 10002, 1010, '02:30:00'), -- Body Mapping 20ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4028, 10002, 1010, '02:30:00'), -- Musiikin terveys 20ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4021, 10002, 1010, '03:00:00'), -- Kirkkomusiikin käytännöt 20ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4022, 10002, 1010, '02:00:00'), -- Nuottikirjoitus 15ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4001, 10002, 1010, '06:00:00'), -- Saksan kielen perusteet 10ppl/ R530 Luentoluokka, 50m2, 18ppl
    (4006, 10002, 1010, '03:30:00'), -- Ruotsin kielen oppitunti 40ppl/ R530 Luentoluokka, 50m2, 18ppl

    (4018, 10002, 1009, '02:00:00'), -- harmonikansoitto / R312 Musiikkiluokka, 16.6m2, 6ppl
    (4029, 10002, 1010, '01:00:00'), -- pianonmusiikin historia / R512 Luentoluokka, 81m2, 30ppl
    (4030, 10002, 1016, '02:25:00'), -- syventävä ensemblelaulu / N522 säestysluokka, 33m2, 8ppl
    (4031, 10002, 1016, '10:00:00'), -- laulu pääinstrumentti / N517 Musiikkiluokka, 15.5m2, 3ppl
    (4009, 10002, 1016, '04:00:00'), -- kanteleensoitto / N517 Musiikkiluokka, 15.5m2, 3ppl
    (4032, 10002, 1010, '02:00:00'), -- jazz line / Studio Erkki, 36m2, 15ppl
    (4033, 10002, 1018, '02:00:00'), -- jazz endemble / N319 Jazz/Lyömä/piano/yhtyeet, 34m2, 5ppl
    (4034, 10002, 1016, '03:00:00'), -- Äänenkäyttö ja huolto / korrepetitiokoulutus 4ppl, N522 Säestysluokka, 33m2, 8m2 
    (4035, 10002, 1018, '06:00:00'), -- Prima vista / korrepetitiokoulutus 2ppl, N319 piano, 34m2, 5ppl 
    (4036, 10002, 1010, '01:00:00'), -- Musiikinhistorian lukupiiri 10ppl / R530 Opetusluokka, 50m2, 18ppl
    (4037, 10002, 1010, '02:00:00'), -- Tohtoriseminaari (sävellys) 17ppl / R530 Opetusluokka, 59m2, 18ppl
    (4038, 10002, 1010, '01:00:00'), -- Musiikkiteknologian perusteet 10ppl
    (4039, 10002, 1010, '02:00:00'); -- Johtamisen pedagogiikka -luentosarja 15ppl

/* --- Insert: AllocCurrentRoundUser * --- */
INSERT INTO AllocCurrentRoundUser(allocId, userId) VALUES
    (10001, 201),
    (10001, 202),
    (10002, 201);

/* ------------------------------------------------------ */
/* DROP PROCEDURES */

DROP PROCEDURE IF EXISTS startAllocation;
DROP PROCEDURE IF EXISTS resetAllocation;
DROP PROCEDURE IF EXISTS allocateSpace;

/* ------------------------------------------------------ */
/* DROP FUNCTIONS */

DROP FUNCTION IF EXISTS getMissingItemAmount;

/* ------------------------------------------------------ */
/* PROCEDURES */

/*--- Procedure: SPACE ALLOCATION ---*/
DELIMITER //

CREATE PROCEDURE allocateSpace(allocRouId INT, subId INT) 
BEGIN
	DECLARE spaceTo INTEGER DEFAULT NULL;
	DECLARE i INTEGER DEFAULT 0; -- loop index
	DECLARE sessions INTEGER DEFAULT 0; -- Total session amount = groupCount * sessionCount
	DECLARE allocated INTEGER DEFAULT 0; -- How many sessions added to AllocSpace
	DECLARE sessionSeconds INTEGER DEFAULT 0; -- How many seconds each session lasts
	DECLARE noSuitableSpace BOOLEAN DEFAULT TRUE; -- If can't allocate set false

	SET sessions := (SELECT groupCount * sessionCount FROM Subject WHERE id = subId);
   	SET allocated := 0; -- How many sessions allocated
   	SET sessionSeconds := (SELECT TIME_TO_SEC(sessionLength) FROM Subject WHERE id = subId);
	
	SET spaceTo := ( -- Help to check if subject can be allocated
        	SELECT ass.spaceId FROM AllocSubjectSuitableSpace ass
        	WHERE ass.missingItems = 0 AND ass.subjectId = subId AND ass.allocRound = allocRouId 
 			LIMIT 1);
 		
	IF spaceTo IS NULL THEN -- If can't find suitable spaces
		SET noSuitableSpace := FALSE;
   	ELSE -- Find for each session space with free time
   		SET i := 0;
   		WHILE (allocated < sessions) OR (i < sessions - allocated) DO -- Try add all subject sessions to spaces	
   			SET spaceTo := (
   				SELECT sp.id FROM AllocSubjectSuitableSpace ass
				LEFT JOIN Space sp ON ass.spaceId = sp.id
				LEFT JOIN AllocSpace al_sp ON ass.spaceId = al_sp.spaceId 
				WHERE ass.subjectId = subId AND ass.missingItems = 0
				GROUP BY sp.id
				HAVING 
				(SELECT TIME_TO_SEC(TIMEDIFF(availableTo, availableFrom)) *5 FROM Space WHERE id = sp.id) - IFNULL(SUM(TIME_TO_SEC(al_sp.totalTime)), 0)  
				>
				(sessionSeconds * (sessions - i - allocated))
				ORDER BY sp.personLimit ASC, sp.area ASC
				LIMIT 1);
			
			IF spaceTo IS NULL THEN -- If can't find space with freetime for specific amount sessions
				SET i := i+1;
			ELSE -- if can find space with freetime for specific amount sessions
				INSERT INTO AllocSpace
					(subjectId, allocRound, spaceId, totalTime) 
				VALUES 
					(subId, allocRouId, spaceTo, SEC_TO_TIME((sessionSeconds * (sessions - i - allocated))))
				ON DUPLICATE KEY UPDATE totalTime = totalTime + SEC_TO_TIME(sessionSeconds * (sessions - i - allocated));
				
				SET i := 0;
				SET allocated := allocated + (sessions - i - allocated);
			END IF;
   			
   		END WHILE;
   
   END IF;
   
   IF sessions = allocated THEN -- If all sessions allocated
   	UPDATE AllocSubject SET isAllocated = 1 WHERE subjectId = subId AND allocRound = allocRouId;
   ELSEIF noSuitableSpace = FALSE THEN -- if can't find any suitable space for the subject
   	UPDATE AllocSubject SET cantAllocate = 1 WHERE subjectId = subId AND allocRound = allocRouId;
   ELSEIF allocated = 0 AND noSuitableSpace = TRUE THEN -- if can't find any space with free time, add all sessions to same space with most freetime
   	SET spaceTo := (SELECT spa.id
					FROM AllocSubjectSuitableSpace suitspace
					LEFT JOIN Space spa ON suitspace.spaceId = sp.id
					LEFT JOIN AllocSpace allspa ON suitspace.spaceId = allspa.spaceId
					WHERE suitspace.subjectId = subId
					AND suitspace.missingItems = 0
					AND suitspace.allocRound = allocRouId
					GROUP BY suitspace.spaceId 
					ORDER BY (TIME_TO_SEC(TIMEDIFF(spa.availableTO, spa.availableFrom)) *5) - IFNULL((SUM(TIME_TO_SEC(allspa.totalTime))), 0) DESC
					LIMIT 1);
				
   	INSERT INTO AllocSpace (subjectId, allocRound, spaceId, totalTime) 
   		VALUES (subId, allocRouId, spaceTo, SEC_TO_TIME(sessionSeconds * sessions)); -- NOT TESTED - NO ENOUGH TEST DATA ATM
   
   	ELSE -- when there is no enough freetime for all sessions in spaces, add rest to same space with others
   		SET spaceTo := (SELECT * FROM
						AllocSpace
						WHERE subjectId = subId
						AND allocRound = allocRouId
						ORDER BY totalTime DESC);
		
		UPDATE AllocSpace SET totalTime=totalTime + (SEC_TO_TIME(sessionSeconds * (sessions - allocated))) 
		WHERE subjectId=subID AND spaceId = spaceTO AND allocRound = allocRouId;
   	
		UPDATE AllocSubject SET isAllocated = 1 WHERE subjectId = subId AND allocRound = allocRouId;
			
   	END IF;

END; //

DELIMITER ;

/* --- Procedure: RESET ALLOCATION --- */
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS  resetAllocation(allocR INTEGER)
BEGIN
	DELETE FROM AllocSpace WHERE allocRound = allocR;
	DELETE FROM AllocSubjectSuitableSpace WHERE allocRound = allocR;
	UPDATE AllocSubject SET isAllocated = 0, priority = null, cantAllocate = 0 WHERE allocRound = allocR;
END; //

DELIMITER ;

/* Procedure: START ALLOCATION */ 
DELIMITER //

CREATE OR REPLACE PROCEDURE startAllocation(allocRouId INT)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE priorityNum INTEGER DEFAULT 1;
	DECLARE subId	INTEGER DEFAULT 0;

	DECLARE subjects CURSOR FOR 
		SELECT allSub.subjectId 
       	FROM AllocSubject allSub 
        LEFT JOIN SubjectEquipment sub_eqp ON allSub.subjectId = sub_eqp.subjectId
        WHERE allSub.allocRound = allocRouId 
        GROUP BY allSub.subjectId 
        ORDER BY sub_eqp.priority DESC;
       
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	OPEN subjects;

	SET priorityNum = 1;

	test : LOOP
		FETCH subjects INTO subId;
		IF finished = 1 THEN LEAVE test;
		END IF;
		-- SET priorityNumber
		UPDATE AllocSubject SET priority = priorityNum WHERE subjectId = subId AND allocRound = allocRouId;
		SET priorityNum = priorityNum +1;
		-- SET Suitable rooms
	    INSERT INTO AllocSubjectSuitableSpace (allocRound, subjectId, spaceId, missingItems)
		SELECT allocRouId, subId, sp.id, getMissingItemAmount(subId, sp.id) AS "missingItems"
		FROM Space sp
		WHERE sp.personLimit >= (SELECT groupSize FROM Subject WHERE id=subId)
		AND sp.area >= (SELECT s.area FROM Subject s WHERE id=subId)
		AND sp.spaceTypeId = (SELECT s.spaceTypeId FROM Subject s WHERE id=subId)
		AND sp.inUse=1
		;
	
	END LOOP test;
	
	CLOSE subjects;

		
END; //
DELIMITER ;


/* ------------------------------------------------------ */
/* FUNCTIONS */

/* Function: get missing item amount in space */
DELIMITER //
CREATE FUNCTION IF NOT EXISTS getMissingItemAmount(subId INT, spaId INT) RETURNS INT
NOT DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(*)
        FROM
    (SELECT equipmentId  FROM SubjectEquipment
    WHERE subjectId = subId
    EXCEPT 
    SELECT equipmentId FROM SpaceEquipment
    WHERE spaceId = spaId) a
);
END; //
DELIMITER ;