<?php

namespace App\Models;

class Order extends \Illuminate\Database\Eloquent\Model
{
    protected $table = 'order';

    protected $fillable = [
        'date'
    ];

    public function products()
    {
        return $this->belongsToMany(Product::class, 'order_has_product');
    }
}
