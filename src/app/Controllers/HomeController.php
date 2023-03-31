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

    public function reseedDB()
    {
        DB::statement('CALL reseed_db()');

        header("Location: " . URL_ROOT);
        die();
    }

    public function addProductsOrders()
    {
        DB::statement('CALL populate_product_order()');

        header("Location: " . URL_ROOT);
        die();
    }

    public function addStocktoAll()
    {
        DB::statement('CALL add_random_stock_to_all_products()');

        header("Location: " . URL_ROOT);
        die();
    }

    public function addStocktoProduct(array $vars)
    {
        DB::statement('CALL add_random_stock_to_product(?)', [$vars['productid']]);

        header("Location: " . URL_ROOT);
        die();
    }
}
