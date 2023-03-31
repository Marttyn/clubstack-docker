<?php

// Routes system
use App\Controllers\HomeController;

$dispatcher = FastRoute\simpleDispatcher(function (FastRoute\RouteCollector $r) {
    $r->addRoute('GET', URL_ROOT, HomeController::class . '/index');
    $r->addRoute('GET', URL_ROOT . 'reseedDB', HomeController::class . '/reseedDB');
    $r->addRoute('GET', URL_ROOT . 'addProductsOrders', HomeController::class . '/addProductsOrders');
    $r->addRoute('GET', URL_ROOT . 'addStocktoAll', HomeController::class . '/addStocktoAll');
    $r->addRoute('GET', URL_ROOT . 'addStocktoProduct', HomeController::class . '/addStocktoProduct');
});
