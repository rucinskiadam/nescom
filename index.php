<?php
	include_once("config.php");		



#formulrz zmiany jezyka
	echo '<form method="POST" action="'.$_SERVER['PHP_SELF'].'" >';
		
		if( $_SESSION['LANG']  == "pl_PL" ){
			echo '<input type="hidden" name="lang" value="en_US" >';
		}else{
			echo '<input type="hidden" name="lang" value="pl_PL" >';
		}
		
		echo '<input type="submit" value="'.(( $_SESSION['LANG']  == "pl_PL" )?_('zmien na angielski'):_('zmien na polski')).'">';
	
	echo '</form>';








			

	if(isset($_POST['user_log_in']) && !isset($_SESSION['l_user'])){
				
		$query="		
				select 
					u.id_user,
					u.login,
					u.account_type,
					u.is_active 
				from 
					users u
				join 
					passwords p
				on 
					u.id_user=p.user_id 
				join 
					personal_datas pd
				on 
					u.id_user=pd.user_id
				where
					(u.login='".$_POST['user_login']."' or pd.email='".$_POST['user_login']."') and
					p.password='".$_POST['user_password']."'
				;
		";		
		$res = pg_query($p_conn, $query);
		
		if(pg_affected_rows($res)==1){
		
			$data = pg_fetch_object($res);
			  echo $data->id_user . "<br>";
			  echo $data->login . "<br>";
			  echo $data->account_type . "<br>";
			  echo $data->is_active . "<br>";
			
			if($data->is_active==TRUE){  
				$_SESSION['l_user'] = new logged_user($data->id_user,$data->login,$data->account_type);
			}else{
				echo '<span>',_('Twoje konto jest nie aktywne sprawdź swoją pocztę lub wyślij ponownie mail aktywacyjny.').'</span>';			
			}
		}else{
			echo '<span>',_('Błędny login lub hasło.').'</span>';			
		}
		
		pg_free_result($res);
		
		history_of_log_in($p_conn,$_POST['user_login'], ((isset($_SESSION['l_user']))?'true':'false') );	
	}
	
	
	if(!isset($_SESSION['l_user']) or $_SESSION['l_user']->logged_in==false  ){
	
	
		echo '<form method="POST" ation="index.php">';
			echo '<input type="text" name="user_login" maxlength="40">';
			echo '<input type="password" name="user_password" maxlength="40">';
			echo '<input type="submit" name="user_log_in" value="'._('Zaloguj').'" maxlength="40">';
		echo '</form>';
	
	}
	
	
	
	#kasowanie sesji###################
	if(isset($_SESSION['l_user'])){
		if(isset($_GET['log_out'])){
			if( time() > $_GET['log_out'] ) 
				$_SESSION['l_user']->log_out();
		}else{
			echo '<a href="./?log_out='.time().'">'._('Wyloguj').'</a>';
		}
	}
	###################################


pg_close($p_conn);
# phpinfo();	
?>
