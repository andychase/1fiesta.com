<?php
// ////// /////// ////////////////////
// 1Fiesta- Author: Andy Chase.

$live = true; // SET TO TRUE WHEN LIVE

// Setup /////////////////////////////
if ($live) ini_set('display_errors','off');
else ini_set('display_errors', 'on');
require_once('libs/Smarty.class.php');

$smarty = new Smarty;
$smarty->setTemplateDir('templates');
$smarty->setCompileDir('templates/compile');
$smarty->setCacheDir('templates/cache');
$smarty->cache_lifetime = 1800;
$smarty->caching = 1;
$compile_check = !$live;

if (!$smarty->isCached("map.tpl")) {
    $events = json_decode(file_get_contents('http://coconut.asperous.us:9200/events/_search'), true);
    if (!is_null($events) && count($events['hits']['hits']))
      $smarty->assign("events", array_map(function($e){return $e['_source'];}, $events['hits']['hits']));
}

$smarty->display("map.tpl");
