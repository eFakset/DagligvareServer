
alter table handel modify column handel_nr int not null AUTO_INCREMENT;
alter table handel auto_increment = 2154;

ALTER TABLE varelinje
 ADD CONSTRAINT FK_varelinje_handel FOREIGN KEY FK_varelinje_handel (handel_nr)
    REFERENCES handel (handel_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

ALTER TABLE bonus
 ADD CONSTRAINT FK_bonus_handel FOREIGN KEY FK_bonus_handel (handel_nr)
    REFERENCES handel (handel_nr)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;
