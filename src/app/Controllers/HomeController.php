<?php

namespace App\Controllers;

use Illuminate\Database\Capsule\Manager as DB;
use JetBrains\PhpStorm\NoReturn;

class HomeController
{
    /**
     * Home page
     *
     * @Route("/")
     * @return void
     */
    public function index(): void
    {
        $products = DB::table('product_details')->get();

        require_once APP_ROOT . '/views/home.php';
    }

    /**
     * Run the reseed_db stored procedure to truncate all tables and reseed the database
     *
     * @Route("/reseedDB")
     * @return void
     */
    #[NoReturn] public function reseedDB(): void
    {
        DB::statement('CALL reseed_db()');

        header("Location: " . URL_ROOT);
        die();
    }

    /**
     * Run the populate_product_order stored procedure to add new products and orders to the database
     *
     * @Route("/addProductsOrders")
     * @return void
     */
    #[NoReturn] public function addProductsOrders(): void
    {
        DB::statement('CALL populate_product_order()');

        header("Location: " . URL_ROOT);
        die();
    }

    /**
     * Run the add_random_stock_to_all_products stored procedure to add a random available stock to all products
     *
     * @Route("/addStocktoAll")
     * @return void
     */
    #[NoReturn] public function addStocktoAll(): void
    {
        DB::statement('CALL add_random_stock_to_all_products()');

        header("Location: " . URL_ROOT);
        die();
    }

    /**
     * Run the add_random_stock_to_product stored procedure to add a random available stock to a specific product
     *
     * @Route("addStocktoProduct")
     * @param array $vars
     * @return void
     */
    #[NoReturn] public function addStocktoProduct(array $vars): void
    {
        try {
            DB::statement('CALL add_random_stock_to_product(?)', [$vars['productid']]);
        } finally {
            header("Location: " . URL_ROOT);
            die();
        }
    }
}
