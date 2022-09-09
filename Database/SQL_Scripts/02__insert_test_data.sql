USE casedb;

/* INSERTS */
/* --- Insert: Department --- */
INSERT INTO Department(name, description) VALUES
	('Jazz', 'Aineryhmän kuvaus'),
    ('Laulumusiikki', 'Aineryhmän kuvaus'),
    ('Piano, harmonikka, kitara ja kantele', 'Aineryhmän kuvaus'),
    ('Musiikkikasvatus', 'Aineryhmän kuvaus'),
    ('MuTri', "Aineryhmän kuvaus"),
    ('Vanha musiikki', "Aineryhmän kuvaus"),
    ('Musiikkiteknologia', 'Aineryhmän kuvaus'),
    ('Musiikinjohtaminen sekä orkesteri- ja kuorotoiminta', 'Aineryhmän kuvaus'),
    ('Taidejohtaminen ja yrittäjyys', 'Aineryhmän kuvaus'),
    ('Avoin Kampus', 'Aineryhmän kuvaus');

/* --- Insert: `User` --- */
INSERT INTO User(name, isAdmin, email) VALUES
    ('sa1001', 1, 'fake_admin@test.co'),
    ('sa1002', 0, 'fake_planner@test.co'),
    ('sa1003', 0, 'fake_planner2@test.co');

/* --- Insert: DepartmentPlanner * --- */
INSERT INTO DepartmentPlanner(userId, departmentId) VALUES
    (202, 101),
    (202, 105),
    (203, 103),
    (203, 104),
    (202, 102);

/* --- Insert: Campus --- */
INSERT INTO `campus` (`id`, `name`, `description`) VALUES
	(301, 'Siba', 'Sibeliusakatemian kampus');
/* --- Insert: Building * --- */
INSERT INTO `building` (`id`, `name`, `description`, `campusId`) VALUES
	(401, 'Musiikkitalo', 'Sibeliusakatemian päärakennus', 301),
	(402, 'N-talo', 'Sibeliusakatemian opetus ja harjoittelu talo ', 301),
	(403, 'R-talo', 'Sibeliusakatemian konserttitalo', 301);
/* --- Insert: Space * --- */
INSERT INTO `space` (`id`, `name`, `area`, `people_capasity`, `buildingId`, `availableFrom`, `availableTo`, `classesFrom`, `classesTo`) VALUES
	(1001, 'S6117', 31.0, 10, 401, '08:00:00', '21:00:00', '09:00:00', '16:00:00'),
	(1002, 'S6104 ', 63.0, 50, 401, '08:00:00', '21:00:00', '10:00:00', '17:00:00'),
	(1003, 'R312', 15.0, 4, 403, '08:00:00', '21:00:00', '08:00:00', '18:00:00');
/* --- Insert: Equipment --- */
INSERT INTO `equipment` (`id`, `name`, `isMovable`, `priority`, `description`) VALUES
	(2001, 'Kontrabasso', 1, 110, 'Kaunis puinen soitin, jolla on neljä kieltä.'),
	(2002, 'Urut', 0, 600, 'Valtavan kokoinen soitin'),
	(2003, 'Kantele', 1, 50, 'Väinämöisen soitin');
/* --- Insert: SpaceEquipment * --- */
INSERT INTO `spaceequipment` (`spaceId`, `equipmentId`) VALUES
	(1001, 2001),
	(1002, 2002),
	(1003, 2003);
/* --- Insert: Program * --- */
INSERT INTO Program (name , departmentId) VALUES
    ('Piano', 103),
    ('Laulutaide pääaineena', 102),
    ('Kitara', 103),
    ('Kantele', 103),
    ('Jazzsävellys', 101),
    ('Laulutaide', 102),
    ('Musiikinteoria pääaineena', 104),
    ('Jazzmusiikin instrumentti- tai lauluopinnot pääaineena', 102),
    ('Fortepiano', 103),
    ('Avoin Kampus', 110);

/* --- Insert: Subject * --- */

/* --- Insert: SubjectEquipment * --- */

/* END */