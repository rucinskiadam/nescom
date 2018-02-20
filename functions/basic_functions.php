<?php

#postgresql connection
######################
function p_conn($host,$port,$database,$user,$user_password){
	
	$conn_string = " host=".$host." port=".$port." dbname=".$database." user=".$user." password=".$user_password." ";
	$p_conn = pg_connect ($conn_string);
	
	if(!$p_conn) {
		return false;
	}
	
	return $p_conn;
}

#historia logowania
###################
function history_of_log_in($p_conn,$login,$succes){
	
	$query="
		INSERT INTO public.log_in(
            login, ip, browser, successfully, login_date, login_time)
    	VALUES ('".$login."', '".((isset($_SERVER['REMOTE_ADDR']))?$_SERVER['REMOTE_ADDR']:'')."','".(isset($_SERVER['HTTP_USER_AGENT'])?$_SERVER['HTTP_USER_AGENT']:'')."', '".$succes."', now()::date, now()::time );
	";
	pg_query($p_conn, $query);
	
}


?>