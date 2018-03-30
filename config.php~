<?php
ini_set('display_errors', '1');
//phpinfo();

		#postgres - produkcyjny
		#dane do logowania
		define( 'h__' , 'localhost'    );
		define( 'p__' , '5432'         );
		define( 'd__' , 'createmo_nescom'  );
		define( 'u__' , 'createmo_salvabitur'  );
		define( 't__' , 'Chrzanek66' );

	########################################################################################
		
	define( '_classes'   , 'classes/'   );
	define( '_functions' , 'functions/' );																	#
																														#
	include_once(_classes."logged_user.php");													         #
																														#
	include_once(_functions."basic_functions.php");													   #
																														#
	session_start();																							   #
														                                                #
	include_once("translate.php");													                  #
														                                                #
	#polaczenie z baza danych													                        #
	$p_conn = p_conn(h__,p__,d__,u__,t__);													            #
																														#
	########################################################################################
	

	

?>