<?php
if($_POST){
file_put_contents("/etc/autopanel/data/users.db",$_POST['user']."\n",FILE_APPEND);
echo "Created";
}
?>
<form method="post">
User:<input name="user">
<button>Create</button>
</form>
