<?php
ob_start();
$GLOBALS['testing'] = true;
require_once('libs/Smarty.class.php');
require_once('./libs/pdo.php');
require_once('./libs/dbal.php');
