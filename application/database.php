<?php
// Enter your Host, username, password, database below.
$con = mysqli_connect("192.168.1.183", "root", "my-secret-pw", "application");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
?>