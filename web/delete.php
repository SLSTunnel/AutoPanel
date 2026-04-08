<?php
if($_POST){
shell_exec("sed -i '/".$_POST['user']."/d' /etc/autopanel/data/users.db");
echo "Deleted";
}
?>
<form method="post">
User:<input name="user">
<button>Delete</button>
</form>
