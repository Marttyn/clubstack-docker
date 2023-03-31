<?php

// Routes system
use App\Controllers\HomeController;

$dispatcher = FastRoute\simpleDispatcher(function (FastRoute\RouteCollector $r) {
    $r->addRoute('GET', URL_ROOT, new HomeController());
});
