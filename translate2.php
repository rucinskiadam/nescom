<?php
/*
	//zmiana jezyka	
	//##############
*/

$def_lang = 'pl_PL';
$def_charset = 'UTF-8';
$set_lang = $def_lang;

$languages = array(
	'pl_PL' => 'Polski',
	'en_US' => 'English'
);


if(!isset($_COOKIE['lang'])) setcookie("lang", $def_lang, strtotime( '+1 day' ), "",false,false);


if(isset($_POST['lang'])){
	$set_lang = $_POST['lang'];
}else if(isset($_COOKIE['lang'])){
	$set_lang = $_COOKIE['lang'];
}

check_lang($set_lang);
set_cookie($set_lang);
set_lang($set_lang,$def_charset);


/*echo $_COOKIE['lang'];
if(isset($_COOKIE['lang'])){
	check_lang($_COOKIE['lang']);
}

if(isset($_POST['lang'])){
	check_lang($_POST['lang']);
}


if( isset($_POST['lang']) ){
	if($_POST['lang']!=$def_lang){
		set_lang($_POST['lang']);
		set_cookie($_POST['lang']);
	}else{
		set_cookie($def_lang);
		setlocale(LC_ALL, $def_lang.'.UTF-8');		
	}
}else{
	if(isset($_COOKIE['lang'])){
		//if($_COOKIE['lang']!=$def_lang){
			set_lang($_COOKIE['lang']);
			set_cookie($_COOKIE['lang']);
		//}else{
		//	setlocale(LC_ALL, $def_lang.'.UTF-8');		
		//}
	}else{
		set_cookie($def_lang);
	}
}
*/




function check_lang(&$lang){
	if(!in_array($lang , array("en_US","pl_PL"))){
			$lang="pl_PL";
	}
}

function set_cookie($lang){
	setcookie("lang", $lang, strtotime( '+1 day' ), "",false,false);
}
	
function set_lang($lang,$charset){	
	//global $def_lang;
	setlocale(LC_ALL, $lang .'.'.$charset);
	
	/*Because the .po file is named messages.po, the text domain must be named
	 * that as well. The second parameter is the base directory to start
 	* searching in. */
	
	//if($lang!=$def_lang){
		bindtextdomain($lang, 'locale');
		bind_textdomain_codeset($lang, $charset);
		/**Tell the application to use this text domain, or messages.mo.*/
		textdomain($lang);
	//}
	
}

function select_lang($lang_key,$set_lang){
	if($lang_key==$set_lang){
			return ' selected ';			
	}
}

echo '<br>locale default: '. Locale::getDefault().'<br>';
echo '<br>cokie: '. $_COOKIE['lang'].'<br>';
/*
	//formulrz zmiany jezyka
*/
echo '<form method="POST" action="'.$_SERVER['PHP_SELF'].'" >';
	
	echo '<select name="lang" onchange="this.form.submit()">';
		foreach($languages as $lang_k=>$lang_name){
			echo '<option value="'.$lang_k.'" '.select_lang($lang_k,$set_lang).'>'.$lang_name.'</option>';
		}
	echo '</select>';

echo '</form>';

/*
	//czy po kolejnym submicie będzie wartość
*/
echo '<form method="POST" action="'.$_SERVER['PHP_SELF'].'" >';		
	echo '<input type="submit" value="test">';
echo '</form>';

/*
	//test tlumaczenia
*/
echo _("tekst przykladowy 1")."<br>";
echo _("tekst przykladowy 2")."<br>";
echo _("tekst przykladowy 3")."<br>";
echo _("tekst przykladowy 4")."<br>";
echo _("tekst przykladowy 5")."<br>";
echo _("tekst przykladowy 6")."<br>";


?>