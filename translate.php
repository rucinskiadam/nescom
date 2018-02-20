<?php


if(!isset($_SESSION['LANG'])) {
	$_SESSION['LANG'] = Locale::getDefault();
}

if(isset($_POST['lang'])){
	if($_POST['lang']!=$_SESSION['LANG'] ){
		$_SESSION['LANG']  = $_POST['lang'];
	}
}

if(!in_array($_SESSION['LANG'] , array("en_US","pl_PL")) ){
	$_SESSION['LANG']  = "pl_PL";
}

	setlocale(LC_ALL, $_SESSION['LANG'] .'.UTF-8');

	/*Because the .po file is named messages.po, the text domain must be named
	 * that as well. The second parameter is the base directory to start
 	* searching in. */
	bindtextdomain('en_US', 'locale');
	bind_textdomain_codeset('en_US', 'UTF8');
	/**Tell the application to use this text domain, or messages.mo.*/
	textdomain('en_US');



?>