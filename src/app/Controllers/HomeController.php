<?php

namespace App\Controllers;

use Illuminate\Database\Capsule\Manager as DB;

class HomeController
{
    public function index()
    {
        $products = DB::table('product_details')->get();

        require_once APP_ROOT . '/views/home.php';
    }
}
