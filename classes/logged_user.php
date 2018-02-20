<?php

class logged_user{
	
	private $user_id;
	private $user_login=false;
	private $account_type=3;
	public $logged_in=false;
	
	function __construct($id,$login,$account_type){
		$this->user_id = $id;
		$this->user_login = $login;
		$this->account_type = $account_type;
		$this->logged_in=true;
	}
	
	function get_account_type(){
		return $this->account_type;	
	}
	
	function get_login(){
		return $this->user_login;	
	}
	
	

	function log_out(){
		session_destroy(); 
		header('Location: ./');
	}	
	
}	



?>