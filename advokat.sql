CREATE TABLE IF NOT EXISTS `advokat_sager` (
    `id` int DEFAULT NULL,
    `clientname` varchar(50) DEFAULT NULL,
    `beskrivelse` varchar (250) DEFAULT NULL,
    `underskrift` varchar(50) DEFAULT NULL,
    `dato` varchar(15) DEFAULT NULL,

    PRIMARY KEY(`id`)
) ENGINE = InnoDB;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_lawyer', 'MS13', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_lawyer', 'MS13', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_lawyer', 'MS13', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('lawyer', 'Advokat')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('lawyer',0,'elev ','Elev ',0,'{}','{}'),
	('lawyer',1,'ansat','Ansat',0,'{}','{}'),
	('lawyer',2,'boss','Chef',0,'{}','{}')
    ;
