<?php
//Turn on error reporting
ini_set('display_errors', 'On');
//Connects to the database
$mysqli = new mysqli("oniddb.cws.oregonstate.edu","novakh-db","96lNBSz8B6QhnBfX","novakh-db");
if($mysqli->connect_errno){
	echo "Connection error " . $mysqli->connect_errno . " " . $mysqli->connect_error;
	}
?> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<body>
<div>
	<table>
		<tr>
			<td>Warriors Cats</td>
		</tr>
		<tr>
			<td>Name</td>
			<td>Age</td>
			<td>Clan</td>
			<td>Occupation</td>
			<td>Mothers Name</td>
			<td>Fathers Name</td>
			<td>Lives Left</td>
			<td>Skill Level</td>
		</tr>
	</table>
</div>

<div>
	<form method="post" action="addcat.php"> 

		<fieldset>
			<legend>Name</legend>
			<p>Name: <input type="text" name="CatName" /></p>
		</fieldset>

		<fieldset>
			<legend>Age</legend>
			<p>Age: <input type="text" name="CatAge" /></p>
		</fieldset>

		<fieldset>
			<legend>Clan</legend>
			<select name="CatClan">
<?php
if(!($stmt = $mysqli->prepare("SELECT Clan_ID, Clan_Name FROM Warriors_Clans"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($Clan_ID, $Clan_Name)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
	echo '<option value=" '. $Clan_ID . ' "> ' . $Clan_Name . '</option>\n';
}
$stmt->close();
?>
			</select>
		</fieldset>
		
		<fieldset>
			<legend>Mothers Name</legend>
			<p>Mothers Name: <input type="text" name="CatMothersName" /></p>
		</fieldset>
		
		<fieldset>
			<legend>Fathers Name</legend>
			<p>Fathers Name: <input type="text" name="CatFathersName" /></p>
		</fieldset>
		
		<fieldset>
			<legend>Lives Left</legend>
			<p>Lives Left: <input type="integer" name="CatLivesLeft" /></p>
		</fieldset>
		<input type="submit" name="add" value="Add Cat" />
		<input type="submit" name="update" value="Update Cat" />
	</form>
</div>

<div>
	<table>
		<tr>
			<td>Warriors Clans</td>
		</tr>
		<tr>
			<td>Name</td>
			<td>Population</td>
		</tr>
	</table>
</div>
 
<div>
	<form method="post" action="addclan.php">

	<fieldset>
			<legend>Clan Name</legend>
			<p>Clan Name: <input type="text" name="ClanName" /></p>
		</fieldset>
	
		<fieldset>
			<legend>Clan Populations</legend>
			<p>Clan Population: <input type="integer" name="ClanPopulation" /></p>
		</fieldset>
		
		<input type="submit" name="add" value="Add Clan" />
		<input type="submit" name="update" value="Update Clan" />
	</form>
</div>

<div>
	<table>
		<tr>
			<td>Warriors Skill Levels</td>
		</tr>
		<tr>
			<td>Name</td>
		</tr>
	</table>
</div>

<div>
	<form method="post" action="addskilllevel.php">
		
		<fieldset>
			<legend>Skill Level</legend>
			<p>Skill Level Name: <input type="text" name="SkillLevelName" /></p>
		</fieldset>
		
		<input type="submit" name="add" value="Add Skill Level" />
	</form>
</div>

<div>
	<table>
		<tr>
			<td>Warriors Certifications</td>
		</tr>
		<tr>
			<td>Name</td>
			<td>Skill Level Required</td>
		</tr>
	</table>
</div>
 
<div>
	<form method="post" action="addcertification.php">
		
		<fieldset>
			<legend>Certification Name</legend>
			<p>Certification Name: <input type="text" name="CertName" /></p>
		</fieldset>
		
		<fieldset>
			<legend>Skill Level Requirement</legend>
			<select name="CertSkillLevelReq">
<?php
if(!($stmt = $mysqli->prepare("SELECT Skill_Level_ID, Skill_Level_Name FROM Warriors_Skill_Levels"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($Skill_Level_ID, $Skill_Level_Name)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
	echo '<option value=" '. $Skill_Level_ID . ' "> ' . $Skill_Level_Name . '</option>\n';
}
$stmt->close();
?>
			</select>
		</fieldset>
		
		<input type="submit" name="add" value="Add Certification" />
		<input type="submit" name="update" value="Update Certification" />
	</form>
</div>

<div>
	<table>
		<tr>
			<td>Warriors Jobs</td>
		</tr>
		<tr>
			<td>Name</td>
			<td>Certification(s) Required</td>
		</tr>
	</table>
</div>
 
<div>
	<form method="post" action="addjob.php">
		
		<fieldset>
			<legend>Job Name</legend>
			<p>Job Name: <input type="text" name="JobName" /></p>
		</fieldset>
		
		<fieldset>
			<legend>Certification Requirement</legend>
			<select name="JobCertReq">
<?php
if(!($stmt = $mysqli->prepare("SELECT Certification_ID, Certification_Name FROM Warriors_Certifications"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($Certification_ID, $Certification_Name)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
	echo '<option value=" '. $Certification_ID . ' "> ' . $Certification_Name . '</option>\n';
}
$stmt->close();
?>
			</select>
		</fieldset>
		
		<input type="submit" name="add" value="Add Job" />
		<input type="submit" name="update" value="Update Job" />
	</form>
</div>

</body>
</html>