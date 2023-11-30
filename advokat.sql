CREATE TABLE IF NOT EXISTS `advokat_sager` (
    `id` int DEFAULT NULL,
    `clientname` varchar(50) DEFAULT NULL,
    `beskrivelse` varchar (250) DEFAULT NULL,
    `underskrift` varchar(50) DEFAULT NULL,
    `dato` varchar(15) DEFAULT NULL,

    PRIMARY KEY(`id`)
) ENGINE = InnoDB;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('lawyer',0,'elev','Elev',20),
	('lawyer',1,'skilled','Fuldmægtig',40),
	('lawyer',2,'boss','Direktør',60),
;

INSERT INTO `jobs` (name, label) VALUES
	('lawyer','Advokat')
;