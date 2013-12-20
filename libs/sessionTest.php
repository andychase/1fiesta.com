<?php
require_once('libs/test.php');
require_once('./libs/pdo.php');

class core_session_test extends PHPUnit_Framework_TestCase 
{
    
    static function setUpBeforeClass() {
        require('./libs/sessions.php');
        
        sess_start();
    }
    
    function setUp()
    {
    }

    function testReadAndWriteSession()
    {
        $_SESSION["testvar"] = "testvalue";
        session_write_close();
        
        session_start();
        $this->assertEquals("testvalue", $_SESSION["testvar"]);
        // Note: phpunit clears this variable at the end of the test and then php saves the blankness.
    }
    
    function testGarbageCollection() {
        $PDO = getpdo::getpdo();
        $sesh_id = uniqid();
        $session_old->id = $sesh_id;
        $session_old->data = "OOLD!";
        $session_old->expires = time() - get_cfg_var("session.gc_maxlifetime") - 1;
        $PDO->prepare("
            INSERT INTO sessions
            VALUES (:id, :data, :expires)")
            ->execute((array)$session_old);
        
        
        $sessionidfinder = $PDO->prepare("
            SELECT id
            FROM sessions
            WHERE id = :id
        ");
        $sessionidfinder->execute((array)$sesh_id);
        $session = $sessionidfinder->fetchObject();
        $this->assertEquals($sesh_id, $session->id);
        
        sess_gc();
        
        $sessionidfinder->execute((array)$sesh_id);
        $session = $sessionidfinder->fetchObject();
        $this->assertEquals(null, $session);
    }

    static function tearDownAfterClass() {
        ob_end_flush();
    }
    
}





