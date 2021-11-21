<?php

include('database.php');
$status = '';
if (!empty($_POST['artists'])){
    if (is_array($_POST['artists'])) {
        $status = "<strong>Music genre of the selected artist:</strong><br />";
        foreach($_POST['artists'] as $artist_id){
            $query = mysqli_query($con,"SELECT * FROM artists WHERE `artist_id`='$artist_id'");
            $row = mysqli_fetch_assoc($query);
            $status .= $row['genre'] . "<br />";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="style.css">
	<title>Infrastructure as Code</title>
</head>
<body>
<!-- As a heading -->
<nav class="navbar navbar-light bg-light">
    <div class="container-fluid">
        <span class="navbar-brand mb-0 h1">Infrastructure as Code</span>
    </div>
</nav>

<div class="container">
<form class="form" name="form" method="post" action="">
    <label><strong>Select Artists:</strong></label><br />
    <table border="0" width="60%">
        <tr>
            <?php
            $count = 0;
            $query = mysqli_query($con,"SELECT * FROM artists");
            foreach($query as $row){
                $count++;
                ?>
                <td width="3%"><input type="checkbox" name="artists[]" value="<?php echo $row["artist_id"]; ?>"></td>
                <td width="30%"><?php echo $row["full_name"]; ?></td>
                <?php
                if($count == 3) { // three items in a row
                    echo '</tr><tr>';
                    $count = 0;
                }
            } ?>
        </tr>
    </table>
    <input class="button" type="submit" name="submit" value="Submit">
</form>
</div>

<br />
<?php echo $status; ?>

<br /><br />

</body>
</html>