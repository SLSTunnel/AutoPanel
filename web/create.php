<?php
session_start();
if(!$_SESSION['ok']) header("Location:login.php");

if($_POST){
$user=$_POST['user'];
$pass=$_POST['pass'];
$days=$_POST['days'];

$exp=date("Y-m-d",strtotime("+$days days"));
$hash=hash("sha256",$pass);

file_put_contents("/etc/autopanel/data/users.db","$user:$hash\n",FILE_APPEND);
file_put_contents("/etc/autopanel/data/expiry.db","$user $exp\n",FILE_APPEND);

echo "Created!";
}
?>

<form method="post">
User:<input name="user"><br>
Pass:<input name="pass"><br>
Days:<input name="days"><br>
<button>Create</button>
</form>
