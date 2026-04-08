<?php
session_start();
if($_POST){
if($_POST['user']=="admin" && $_POST['pass']=="admin123"){
$_SESSION['ok']=1;
header("Location:index.php");
}}
?>
<form method="post">
User:<input name="user">
Pass:<input type="password" name="pass">
<button>Login</button>
</form>
