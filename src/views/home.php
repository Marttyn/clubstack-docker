<?php
/**
 * @var Illuminate\Support\Collection $products
 * @var stdClass $product
 */
?>
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <title>Product Information</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h1>Product Information</h1>
    <a href="/reseedDB">Reset DB</a><br />
    <a href="/addProductsOrders">Rerun populate product and order procedure</a><br />
    <a href="/addStocktoAll">Add random stock to all products</a><br />
    <form action="/addStocktoProduct" method="get">
        <label for="productid">Product ID</label>
        <input type="text" name="productid" id="productid" required>
        <button type="submit">Add random stock to the product</button>
    </form>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>Product ID</th>
            <th>Stock Available</th>
            <th>Present in how many orders</th>
            <th>Quantity Ordered</th>
            <th>Products sold</th>
            <th>Average Quantity Ordered</th>
            <th>Average Quantity Purchased</th>
        </tr>
        </thead>
        <tbody>
        <!-- Loop through the products and output their information in each row of the table -->
        <?php if (isset($products)) foreach ($products as $product) : ?>
            <tr>
            <?php foreach ($product as $key => $value) : ?>
                    <td><?= $value ?></td>
            <?php endforeach; ?>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.1.3/js/bootstrap.min.js"></script>
</body>
</html>
