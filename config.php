<?php


	if(false) {	
		#postgres - produkcyjny
		#dane do logowania
		define( 'h__' , 'localhost'    );
		define( 'p__' , '5432'         );
		define( 'd__' , '25546772_01'  );
		define( 'u__' , '25546772_01'  );
		define( 't__' , 'iOcD7OCp#aTx' );
	}else{
		#postgres - testowy
		#dane do logowania
		define( 'h__' , 'localhost'    );
		define( 'p__' , '5432'         );
		define( 'd__' , 'nescom'       );
		define( 'u__' , 'adam'         );
		define( 't__' , 'Adaruc201292' );
	}
	
	
	define( '_classes'   , './classes/'   );
	define( '_functions' , './functions/' );
	

?>