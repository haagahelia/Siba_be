/* Subject no allocated in current season */ 
SELECT Subject.id, Subject.name, al.allocRound 
FROM Subject 
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE al.allocRound != 10001 or al.allocRound IS NULL;

/* SubjectEquipment priority > Globalsettings.X */ 
SELECT Subject.id, Subject.name, SubjectEquipment.priority, al.allocRound
FROM Subject JOIN SubjectEquipment ON Subject.id=SubjectEquipment.subjectId
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE SubjectEquipment.priority >= (SELECT numberValue FROM GlobalSetting)
AND al.allocRound IS NULL
ORDER BY SubjectEquipment.priority DESC;

/* Subject Type equals to single practice */ 
/* DO NO USE !!! */ 
SELECT Subject.id, Subject.name, SubjectEquipment.priority, Subject.subjectTypeId 
FROM Subject JOIN SubjectEquipment ON Subject.id=SubjectEquipment.subjectId
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE Subject.subjectTypeId=802
AND al.allocRound IS NULL
ORDER BY SubjectEquipment.priority DESC;

/* Subject type equals to group practice */
/* DO NO USE !!! */ 
SELECT Subject.id, Subject.name, SubjectEquipment.priority , Subject.subjectTypeId
FROM Subject 
JOIN SubjectEquipment ON Subject.id=SubjectEquipment.subjectId
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE Subject.subjectTypeId=804
AND al.allocRound IS NULL
ORDER BY SubjectEquipment.priority DESC;

/* Subject type equals to theory with subjectEquipment priorities */
/* DO NO USE !!! */ 
SELECT Subject.id, Subject.name, Subject.subjectTypeId
FROM Subject 
JOIN SubjectEquipment ON Subject.id=SubjectEquipment.subjectId
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE Subject.subjectTypeId=801
AND al.allocRound IS NULL
ORDER BY SubjectEquipment.priority DESC;

/* Theory subject without requirements */ 
/* DO NO USE !!! */ 
SELECT Subject.id, Subject.name FROM Subject 
LEFT JOIN SubjectEquipment ON Subject.id=SubjectEquipment.subjectId
LEFT JOIN AllocSubject as al ON Subject.id=al.subjectId 
WHERE SubjectEquipment.subjectId IS NULL
AND al.allocRound IS NULL
AND Subject.subjectTypeId=801;


/* SUBJECT SELECTS  */

/* space in use */
SELECT * FROM Space
WHERE inUse=1;

/* personLimit >= groupSize. DON'T USE THIS!!! */ 
SELECT id, personLimit, area 
FROM Space 
WHERE personLimit >= (SELECT groupSize FROM Subject WHERE id=4002)
AND inUse=1;

/* Enuff roomspace. DON'T USE THIS!!! */
SELECT id, personLimit, area 
FROM Space 
WHERE area >= (SELECT area FROM Subject WHERE id=4003)
AND inUse=1;

/* Last 2 combined */
/* personLimit >= groupSize & area >= area */ 
SELECT id, personLimit, area 
FROM Space 
WHERE personLimit >= (SELECT groupSize FROM Subject WHERE id=4002)
AND area >= (SELECT area FROM Subject WHERE id=4002)
AND inUse=1;

