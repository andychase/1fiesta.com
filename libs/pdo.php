<?php
// Database abstraction.
/*
    $data = array( 'name' => 'Cathy', 'addr' => '9 Dark and Twisty', 'city' => 'Cardiff' );  
     
    $STH = $DBH->("INSERT INTO folks (name, addr, city) value (:name, :addr, :city)");  
    $STH->execute($data);
    
    # creating the statement  
    $STH = $DBH->query('SELECT name, addr, city from folks');  
    
    # setting the fetch mode  
    $STH->setFetchMode(PDO::FETCH_OBJ);  
    
    # showing the results  
    while($row = $STH->fetch()) {  
        echo $row->name . "\n";  
        echo $row->addr . "\n";  
        echo $row->city . "\n";  
    } 
*/

class getpdo
{
    //Singleton pattern for performance: only one connection.
    private static $instance;
    private static $pdo = 0;

    private function __construct()
    {
    }
    
    private function  createpdo() {
        try {
            $PDO = new PDO("mysql:host=localhost;dbname=asper2_go",
            "asper2_scripts", "=tp*BH5JjkE&");
        } catch(PDOException $e) {
            echo $e->getMessage();
        }
        //Configure PDO here
        $PDO->setAttribute(PDO::ATTR_EMULATE_PREPARES,false);
        
        if($GLOBALS['testing'] == true) {
            $PDO->beginTransaction();
            $PDO->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } else if ($GLOBALS['BASEURL'] != "localhost") {
            $PDO->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT);
        }
        return $PDO;
    }

    public static function getpdo()
    {
        if (!isset(self::$instance)) {
            $className = __CLASS__;
            self::$pdo = self::createpdo();
            self::$instance = new $className;
        }
        return self::$pdo;
    }
    
    public static function geter()
    {
        return implode("-", self::getpdo()->errorInfo());
    }

    public function __clone()
    {
        trigger_error('Clone is not allowed.', E_USER_ERROR);
    }

    public function __wakeup()
    {
        trigger_error('Unserializing is not allowed.', E_USER_ERROR);
    }
}
