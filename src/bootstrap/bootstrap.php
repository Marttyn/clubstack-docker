<?php

use Illuminate\Database\Capsule\Manager as Capsule;

$capsule = new Capsule();

$capsule->addConnection([
    "driver" => "mysql",
    "host" => constant('DB_HOST'),
    "database" => constant('DB_NAME'),
    "username" => constant('DB_USER'),
    "password" => constant('DB_PASS')
]);

$capsule->setAsGlobal();

$capsule->bootEloquent();
