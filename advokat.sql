CREATE TABLE IF NOT EXISTS `advokat_sager` (
    `id` int DEFAULT NULL,
    `clientname` varchar(50) DEFAULT NULL,
    `beskrivelse` varchar (250) DEFAULT NULL,
    `underskrift` varchar(50) DEFAULT NULL,
    `dato` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),

    PRIMARY KEY(`id`)
) ENGINE = InnoDB;