<?php
session_start();
if(!isset($_SESSION['ok'])) header("Location: login.php");

echo "<h1>👑 [KING]DevSupport Dashboard</h1>";
echo "<a href='create.php'>Create User</a> | ";
echo "<a href='delete.php'>Delete User</a><br><br>";

$data = file("/etc/autopanel/data/expiry.db");

foreach($data as $line){
    echo $line."<br>";
}
?>
