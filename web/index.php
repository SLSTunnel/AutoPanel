<?php
session_start();
if(!$_SESSION['ok']) header("Location:login.php");

echo "<h2>[KING]DevSupport Panel</h2>";
echo nl2br(file_get_contents("/etc/autopanel/data/expiry.db"));
?>
