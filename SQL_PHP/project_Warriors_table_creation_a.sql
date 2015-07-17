SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `Warriors_Characters`;
DROP TABLE IF EXISTS `Warriors_Clans`;
DROP TABLE IF EXISTS `Warriors_Skill_Levels`;
DROP TABLE IF EXISTS `Warriors_Certifications`;
DROP TABLE IF EXISTS `Warriors_Jobs`;

CREATE TABLE Warriors_Characters (
  Character_ID INT NOT NULL AUTO_INCREMENT,
  Character_Name VARCHAR(45) NOT NULL,
  Age INT NOT NULL,
  Clan_ID INT NOT NULL, 							
  Job_ID INT NOT NULL,
  Mothers_Name VARCHAR(45) DEFAULT NULL,
  Fathers_Name VARCHAR(45) DEFAULT NULL,
  Lives_Left INT NOT NULL,
  Skill_Level_ID INT NOT NULL,
  PRIMARY KEY (Character_ID),
  FOREIGN KEY (Clan_ID) REFERENCES Warriors_Clans (Clan_ID),										
  FOREIGN KEY (Skill_Level_ID) REFERENCES Warriors_Skill_Levels (Skill_Level_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

 
CREATE TABLE Warriors_Clans (
  Clan_ID INT NOT NULL AUTO_INCREMENT,
  Clan_Name VARCHAR(45) NOT NULL,
  Population INT NOT NULL,
  PRIMARY KEY (Clan_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  
CREATE TABLE Warriors_Skill_Levels (
  Character_ID INT NOT NULL,
  Skill_Level_ID INT NOT NULL AUTO_INCREMENT,
  Skill_Level_Name VARCHAR(45) NOT NULL,
  PRIMARY KEY (Skill_Level_ID),
  UNIQUE KEY (Character_ID,Skill_Level_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID)  
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE Warriors_Certifications (
  Certification_ID INT NOT NULL AUTO_INCREMENT,
  Certification_Name VARCHAR(45) NOT NULL,
  Skill_Level_Required_ID INT NOT NULL,
  PRIMARY KEY(Certification_ID),
  UNIQUE KEY(Character_ID, Certification_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID),							
  FOREIGN KEY (Skill_Level_Required_ID) REFERENCES Warriors_Skill_Levels (Skill_Level_ID)				
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  

CREATE TABLE Warriors_Jobs (
  Job_ID INT NOT NULL AUTO_INCREMENT,
  Job_Name VARCHAR(45) NOT NULL,
  Certification_Required_ID INT NOT NULL,
  PRIMARY KEY(Job_ID),
  UNIQUE KEY (Character_ID, Job_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID),							
  FOREIGN KEY (Certification_Required_ID) REFERENCES Warriors_Certifications(Certification_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('ClanName1', 45);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('ClanName2', 46);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('ClanName3', 47);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('ClanName4', 48);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('ClanName5', 49);  
  
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Job_ID,Mothers_Name,Fathers_Name,Lives_Left,Skill_Level_ID) VALUES ('CharacterName1',6,'ClanName1','JobName1','Moms Name','Dads Name',8,'SkillName1');
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Job_ID,Mothers_Name,Fathers_Name,Lives_Left,Skill_Level_ID) VALUES ('CharacterName2',5,'ClanName2','JobName2','Moms Name','Dads Name',7,'SkillName1');
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Job_ID,Mothers_Name,Fathers_Name,Lives_Left,Skill_Level_ID) VALUES ('CharacterName3',4,'ClanName3','JobName3','Moms Name','Dads Name',6,'SkillName2');
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Job_ID,Mothers_Name,Fathers_Name,Lives_Left,Skill_Level_ID) VALUES ('CharacterName4',3,'ClanName4','JobName3','Moms Name','Dads Name',5,'SkillName3');
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Job_ID,Mothers_Name,Fathers_Name,Lives_Left,Skill_Level_ID) VALUES ('CharacterName5',2,'ClanName4','JobName4','Moms Name','Dads Name',4,'SkillName4');

INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('SkillName1');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('SkillName2');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('SkillName3');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('SkillName4');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('SkillName5');

INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('CertName1', 'SkillName1');
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('CertName2', 'SkillName2');
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('CertName3', 'SkillName3');
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('CertName4', 'SkillName4');
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('CertName5', 'SkillName5');

INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('JobName1','CertName1');
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('JobName2','CertName2');
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('JobName3','CertName3');
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('JobName4','CertName4');
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('JobName5','CertName5'); 