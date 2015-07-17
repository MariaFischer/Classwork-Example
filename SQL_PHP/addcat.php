<?php
//Turn on error reporting
ini_set('display_errors', 'On');
//Connects to the database
$mysqli = new mysqli("oniddb.cws.oregonstate.edu","novakh-db","96lNBSz8B6QhnBfX","novakh-db"); 
if(!$mysqli || $mysqli->connect_errno){
	echo "Connection error " . $mysqli->connect_errno . " " . $mysqli->connect_error;
	}
	
if(!($stmt = $mysqli->prepare("INSERT INTO Warriors_Characters(Character_Name,Age,Clan_ID,Mothers_Name,Fathers_Name,Lives_Left) VALUES (?,?,?,?,?,?)"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}
if(!($stmt->bind_param("siissi",$_POST['CatName'],$_POST['CatAge'],$_POST['CatClan'],$_POST['CatMothersName'],$_POST['CatFatherName'],$_POST['CatLivesLeft']))){
	echo "Bind failed: "  . $stmt->errno . " " . $stmt->error;
}
if(!$stmt->execute()){
	echo "Execute failed: "  . $stmt->errno . " " . $stmt->error;
} else {
	echo "Added " . $stmt->affected_rows . " rows to Warriors_Characters.";
}
?>