<?php
ini_set('display_errors', '1');
echo $url="http://api.nbp.pl/api/exchangerates/rates/c/usd/last/10/?format=xml";
	echo '<br>---<br>';

$xml=simplexml_load_file($url);



foreach($xml->Rates->Rate as $k=>$v){
		print_r($v);
	echo '<br>---<br>';

}

?>