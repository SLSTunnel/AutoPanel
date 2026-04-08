<?php
session_start();
if(!$_SESSION['ok']) header("Location:login.php");

echo "<h2>👑 [KING]DevSupport Panel</h2>";
echo "<a href='create.php'>Create</a> | <a href='delete.php'>Delete</a><br><br>";

echo nl2br(file_get_contents("/etc/autopanel/data/expiry.db"));
?>
