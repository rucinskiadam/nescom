<?php

class translate{

	private $default_lang = "pl_PL";
	private $translation_catalogs = array("en_US"=>"en_US");
	private $available_languages = array("pl_PL","en_US");
	private $set_lang;
	
	function __construct( $lang = null ){
		
		
		if(!in_array($lang, $this->available_languages) or empty($lang) or is_null($lang)){
			$lang = $this->default_language;
		}		
		
		
					
		
		if(!in_array($lang,$this->available_languages)){		
			
			$this->set_lang = $this->default_lang;
			
		}else{
			
			$this->set_lang = $lang;
			
		}
		
		if(!isset($_COOKIE['lang'])){
			setcookie("lang", $this->set_lang, time()+3600, "",false,false);
		}else{
					
		}
		
		/*if($lang != 0){
			
			validatae_lang($lang,$this->available_languages,$this->default_lang);		
				
			if(isset($_COOKIE["lang"])){
				validatae_lang($_COOKIE['lang'],$this->available_languages,$this->default_lang);	
			}
			
			$this->set_lang = $lang;
			
		}else{
			
			if(isset($_COOKIE["lang"])){

				vlidatae_lang($_COOKIE['lang'],$this->available_languages,$this->default_lang);	
				$this->set_lang  = $_COOKIE['lang'];
				
			}
			
		}
		
		setcookie("lang", $this->set_lang, time()+3600, "",false,false);
		*/
	
	}
	
	function set_lang(){
		
		/*if( $this->set_lang == $this->default_lang ) {
			$translation_catalog[0] = $this->translation_catalogs[0];
		}else{
			$translation_catalog = $this->set_lang;		
		}*/
		
		setlocale(LC_ALL, $this->set_lang .'.UTF-8');
	
		/*Because the .po file is named messages.po, the text domain must be named
		 * that as well. The second parameter is the base directory to start
	 	* searching in. */
		bindtextdomain($translation_catalog[0], 'locale');
		bind_textdomain_codeset($translation_catalog[0], 'UTF8');
		/**Tell the application to use this text domain, or messages.mo.*/
		textdomain($translation_catalog[0]);
	
	}
		

}


	$lang =  new translate(()$_POST['lang']);
	$lang -> set_lang();

?>