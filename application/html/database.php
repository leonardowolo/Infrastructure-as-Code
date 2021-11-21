<?php
// Enter your Host, username, password, database below.
$con = mysqli_connect("iac-team3.westeurope.cloudapp.azure.com", "root", "example", "application");

// Check connection to database
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
?>