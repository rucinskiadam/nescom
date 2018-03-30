<?php

class translate{

	private $default_lang = "pl_PL";
	private $translation_catalogs = array("en_US");
	private $available_languages = array("pl_PL","en_US");
	private $set_lang;
	
	function __construct($lang = null ){
		
		if($lang != null){
			
			validatae_lang($lang,$this->available_languages,$this->default_lang);		
				
			if(isset($_COOKIE["lang"])){
				validatae_lang($_COOKIE['lang'],$this->available_languages,$this->default_lang);	
			}
			
			$this->set_lang = $lang;
			
		}else{
			
			if(isset($_COOKIE["lang"])){

				validatae_lang($_COOKIE['lang'],$this->available_languages,$this->default_lang);	
				$this->set_lang  = $_COOKIE['lang'];
				
			}
			
		}
		
		setcookie("lang", $this->set_lang, time()+3600, "",false,false);
	
	}
	
	function set_lang(){
		
		if( $this->set_lang == $this->default_lang ) {
			$translation_catalog = $this->translation_catalogs[0];
		}else{
			$translation_catalog = $this->set_lang;		
		}
		
		setlocale(LC_ALL, $this->set_lang .'.UTF-8');
	
		/*Because the .po file is named messages.po, the text domain must be named
		 * that as well. The second parameter is the base directory to start
	 	* searching in. */
		bindtextdomain($translation_catalog, 'locale');
		bind_textdomain_codeset($translation_catalog, 'UTF8');
		/**Tell the application to use this text domain, or messages.mo.*/
		textdomain($translation_catalog);
	
	}
		

}
	function validatae_lang(&$str_lang,$lang_array=array(),$default_lang){
		if($str_lang != null){	
			if(!in_array($str_lang,$lang_array)){		
				$str_lang = $default_lang;
			}	
		}
	}

$lang = new translate(((isset($_POST['lang']))?$_POST['lang']:''));
$lang->set_lang();



#formulrz zmiany jezyka
	echo '<form method="POST" action="'.$_SERVER['PHP_SELF'].'" >';
		
		if( $_COOKIE['lang']  == "pl_PL" ){
			echo '<input type="hidden" name="lang" value="en_US" >';
		}else{
			echo '<input type="hidden" name="lang" value="pl_PL" >';
		}
		
		echo '<input type="submit" value="'.(( $_COOKIE['lang']  == "pl_PL" )?'zmien na angielski':'zmien na polski').'">';
	
	echo '</form>';


?>