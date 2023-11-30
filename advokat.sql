CREATE TABLE IF NOT EXISTS `advokat_sager` (
    `id` int DEFAULT NULL,
    `clientname` varchar(50) DEFAULT NULL,
    `beskrivelse` varchar (250) DEFAULT NULL,
    `underskrift` varchar(50) DEFAULT NULL,
    `dato` varchar(15) DEFAULT NULL,

    PRIMARY KEY(`id`)
) ENGINE = InnoDB;