
<?php

include('database.php');
$status = '';
if (!empty($_POST['artist'])){
  if (is_array($_POST['artist'])) {
	  $status = "<strong>You selected the below artists:</strong><br />";
	foreach($_POST['artist'] as $artist_id){
		$query = mysqli_query($con,"SELECT * FROM artist WHERE `artist_id`='$artist_id'");
		$row = mysqli_fetch_assoc($query);
		$status .= $row['first_name'] . "<br />";
    }
  }
}
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet" type="text/css" href="style.css">
<title>Infrastructure as Code</title>
</head>
<body>
<form name="form" method="post" action="">
<label><strong>Select Artists:</strong></label><br />
<table border="0" width="60%">
<tr>
<?php
$count = 0;
$query = mysqli_query($con,"SELECT * FROM artist");
foreach($query as $row){
	$count++;
?>
<td width="3%"><input type="checkbox" name="artist[]" value="<?php echo $row["artist_id"]; ?>"></td>
<td width="30%"><?php echo $row["first_name"]; ?></td>
<?php
if($count == 3) { // three items in a row
        echo '</tr><tr>';
        $count = 0;
    }
} ?>
</tr>
</table>
<input type="submit" name="submit" value="Submit">
</form>

<br />
<?php echo $status; ?>

<br /><br />
<a href="https://www.allphptricks.com/display-data-from-database-into-html-table-using-php/">Tutorial Link</a> <br /><br />
For More Web Development Tutorials Visit: <a href="https://www.allphptricks.com/">AllPHPTricks.com</a>
</body>
</html>