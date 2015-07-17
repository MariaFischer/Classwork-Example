SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `Warriors_Characters`;
DROP TABLE IF EXISTS `Warriors_Clans`;
DROP TABLE IF EXISTS `Warriors_Skill_Levels`;
DROP TABLE IF EXISTS `Warriors_Character_Skills`;
DROP TABLE IF EXISTS `Warriors_Certifications`;
DROP TABLE IF EXISTS `Warriors_Character_Certifications`;
DROP TABLE IF EXISTS `Warriors_Jobs`;
DROP TABLE IF EXISTS `Warriors_Character_Jobs`;

CREATE TABLE Warriors_Characters (
  Character_ID INT NOT NULL AUTO_INCREMENT,
  Character_Name VARCHAR(45) NOT NULL,
  Age INT NOT NULL,
  Clan_ID INT NOT NULL, 							
  Mothers_Name VARCHAR(45) DEFAULT NULL,
  Fathers_Name VARCHAR(45) DEFAULT NULL,
  Lives_Left INT NOT NULL,
  PRIMARY KEY (Character_ID),
  FOREIGN KEY (Clan_ID) REFERENCES Warriors_Clans (Clan_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE Warriors_Clans (
  Clan_ID INT NOT NULL AUTO_INCREMENT,
  Clan_Name VARCHAR(45) NOT NULL,
  Population INT NOT NULL,
  PRIMARY KEY (Clan_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  
CREATE TABLE Warriors_Skill_Levels (
  Skill_Level_ID INT NOT NULL AUTO_INCREMENT,
  Skill_Level_Name VARCHAR(45) NOT NULL,
  PRIMARY KEY (Skill_Level_ID)  
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
CREATE TABLE Warriors_Character_Skills (
  Character_ID INT NOT NULL,
  Skill_Level_ID INT NOT NULL,
  PRIMARY KEY (Character_ID,Skill_Level_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID),
  FOREIGN KEY (Skill_Level_ID) REFERENCES Warriors_Skill_Levels (Skill_Level_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE Warriors_Certifications (
  Certification_ID INT NOT NULL AUTO_INCREMENT,
  Certification_Name VARCHAR(45) NOT NULL,
  Skill_Level_Required_ID INT NOT NULL,
  PRIMARY KEY(Certification_ID),						
  FOREIGN KEY (Skill_Level_Required_ID) REFERENCES Warriors_Skill_Levels (Skill_Level_ID)				
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
CREATE TABLE Warriors_Character_Certifications (
  Character_ID INT NOT NULL,
  Certification_ID INT NOT NULL,
  PRIMARY KEY (Character_ID,Certification_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID),
  FOREIGN KEY (Certification_ID) REFERENCES Warriors_Certifications (Certification_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
CREATE TABLE Warriors_Jobs (
  Job_ID INT NOT NULL AUTO_INCREMENT,
  Job_Name VARCHAR(45) NOT NULL,
  Certification_Required_ID INT NOT NULL,
  PRIMARY KEY(Job_ID),						
  FOREIGN KEY (Certification_Required_ID) REFERENCES Warriors_Certifications(Certification_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
  

CREATE TABLE Warriors_Character_Jobs (
  Character_ID INT NOT NULL,
  Job_ID INT NOT NULL,
  PRIMARY KEY (Character_ID,Job_ID),
  FOREIGN KEY (Character_ID) REFERENCES Warriors_Characters (Character_ID),
  FOREIGN KEY (Job_ID) REFERENCES Warriors_Jobs (Job_ID)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('Thunder Clan', 36);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('River Clan', 27);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('Wind Clan', 23);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('Shadow Clan', 22);
INSERT INTO Warriors_Clans (Clan_Name,Population) VALUES ('Star Clan', 100000);  
  
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Kit');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Apprintice');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Warrior');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Medicine');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Deputy');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Leader');
INSERT INTO Warriors_Skill_Levels (Skill_Level_Name) VALUES ('Elder');

INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Assistant', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Apprintice'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Medicine', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Medicine'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Trainer', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Warrior'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Hunter', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Warrior'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Warrior', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Warrior'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Deputy', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Deputy'));
INSERT INTO Warriors_Certifications (Certification_Name,Skill_Level_Required_ID) VALUES ('Leader', (SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Leader'));

INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Cleaner',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Assistant'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Warrior',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Warrior',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Hunter'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Warrior',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Trainer'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Medicine',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Medicine'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Deputy',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Deputy',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Deputy',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Hunter'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Deputy',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Trainer'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Leader',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Leader')); 
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Leader',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Leader',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior')); 
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Leader',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Hunter'));
INSERT INTO Warriors_Jobs (Job_Name,Certification_Required_ID) VALUES ('Leader',(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Trainer'));

INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Firestar',36,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Thunder Clan'),'Nutmeg','Jake',8);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Brambleclaw',29,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Thunder Clan'),'Goldenflower ','Tigerstar',1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Jayfeather',24,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Thunder Clan'),'Squrrelflight','Brambleclaw',1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Blackstar',50,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Shadow Clan'),'Hollyflower',NULL,5);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Rowanclaw',22,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Shadow Clan'),NULL,NULL,1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Littlecloud',36,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Shadow Clan'),'Newtspeck',NULL,1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Onestar',43,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Wind Clan'),'Wrenwing',NULL,3);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Ashfoot',39,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Wind Clan'),NULL,NULL,1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Kestrelflight',34,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'Wind Clan'),'Sandstorm','Firestar',1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Mistystar',59,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'River Clan'),'Bluestar','Oakheart',1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Reedwhisker',48,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'River Clan'),'Mistystar',NULL,1);
INSERT INTO Warriors_Characters (Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES ('Mothwing',30,(SELECT Clan_ID FROM Warriors_Clans WHERE Clan_Name = 'River Clan'),'Sasha','Tigerstar',1);

INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Firestar'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Leader'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Brambleclaw'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Deputy'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Jayfeather'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Medicine'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Blackstar'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Leader'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Rowanclaw'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Deputy'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Littlecloud'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Medicine'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Onestar'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Leader'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Ashfoot'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Deputy'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Kestrelflight'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Medicine'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mistystar'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Leader'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Reedwhisker'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Deputy'));
INSERT INTO Warriors_Character_Skills (Character_ID,Skill_Level_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mothwing'),(SELECT Skill_Level_ID FROM Warriors_Skill_Levels WHERE Skill_Level_Name = 'Medicine'));

INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Firestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Firestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Firestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Brambleclaw'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Brambleclaw'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Jayfeather'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Blackstar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Blackstar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Blackstar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Rowanclaw'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Rowanclaw'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Littlecloud'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Onestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Onestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Onestar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Ashfoot'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Ashfoot'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Kestrelflight'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mistystar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mistystar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mistystar'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Reedwhisker'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Reedwhisker'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Warrior'));
INSERT INTO Warriors_Character_Certifications (Character_ID,Certification_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mothwing'),(SELECT Certification_ID FROM Warriors_Certifications WHERE Certification_Name = 'Medicine'));


INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Firestar'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Leader' and Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Brambleclaw'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Deputy' and Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Jayfeather'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Medicine' and Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Blackstar'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Leader'and Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Rowanclaw'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Deputy' and Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'LittleCloud'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Medicine' and Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Onestar'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Leader'and Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Ashfoot'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Deputy' and Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Kestrelflight'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Medicine' and Certification_Name = 'Medicine'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mistystar'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Leader'and Certification_Name = 'Leader'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Reedwhisker'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Deputy' and Certification_Name = 'Deputy'));
INSERT INTO Warriors_Character_Jobs (Character_ID,Job_ID) VALUES ((SELECT Character_ID FROM Warriors_Characters WHERE Character_Name = 'Mothwing'),(SELECT Job_ID FROM Warriors_Jobs INNER JOIN Warriors_Certifications ON Certification_Required_ID = Certification_ID WHERE Job_Name = 'Medicine' and Certification_Name = 'Medicine'));