<?php
/**
 * @var Illuminate\Database\Eloquent\Collection $products
 * @var App\Models\Product $product
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
        <?php foreach ($products as $product) : ?>
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
