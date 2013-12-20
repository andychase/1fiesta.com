<?php

use Doctrine\Common\ClassLoader;
require_once 'libs/Doctrine/Common/ClassLoader.php';
$classLoader = new ClassLoader('Doctrine', 'libs');
$classLoader->register();

$config = new \Doctrine\DBAL\Configuration();

$dbal = \Doctrine\DBAL\DriverManager::getConnection(array('pdo' => getpdo::getpdo()), $config);
