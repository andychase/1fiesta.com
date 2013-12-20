<?php
/* Sessions - A override to use the db for sessions through PDO */
/*
 Session, browser persistence.
 
 id - Mapped to cookie.
 data - Variables in session
 Expires - server timestamp for when it should go away.
 
 TODO 18: Protect the session! Should store info about the browser providing the cookie the first time,
       and only let the person on if they have that same info.
*/
function sess_open($save_path, $session_name)
{
    // Creeeak
    return true;
}

function sess_close()
{
    // Slam.
    return true;
}

function sess_read($id)
{
    // Here ya go
    $sess_read = getpdo::getpdo()->prepare("
        SELECT data
        FROM   sessions
        WHERE  id = :id
    ");
    $sess_read->execute(array($id));
    return $sess_read->fetchObject()->data;
}

function sess_write($id, $data)
{
    // Scribble...
    $sess_write = getpdo::getpdo()->prepare("
        REPLACE INTO sessions
            VALUES (:id, :data, :expires)
    ");
    
    $session->id = $id;
    $session->data = $data;
    $session->expires = time() + get_cfg_var("session.gc_maxlifetime");
    $sess_write->execute((array)$session);
    return true;
}

function sess_destroy($id)
{
    // KABOOM
    getpdo::getpdo()
        ->prepare("
        DELETE *
        FROM sessions
        WHERE id = :id")
        ->execute(array($id));
    return true;
}

function sess_gc()
{
    // Clean up those nasty expired sessions
    getpdo::getpdo()
        ->prepare("
        DELETE FROM sessions
        WHERE expires < :time")
        ->execute(array(time()));
    return true;
}

function sess_start() {
    session_set_save_handler("sess_open", "sess_close", "sess_read", "sess_write", "sess_destroy", "sess_gc");
    session_start();
    
    register_shutdown_function('session_write_close'); //Fixes a bug in php 5.2
    
    // proceed to use sessions normally
}



