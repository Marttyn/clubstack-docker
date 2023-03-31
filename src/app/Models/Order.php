<?php

namespace App\Models;

class Order extends \Illuminate\Database\Eloquent\Model
{
    /**
     * Table name
     *
     * @var string $table
     */
    protected string $table = 'order';

    /**
     * Model attributes that can be mass modified
     *
     * @var string[] $fillable
     */
    protected array $fillable = [
        'date'
    ];

    /**
     * Many-to-many relationship with products
     *
     * @return mixed
     */
    public function products(): mixed
    {
        return $this->belongsToMany(Product::class, 'order_has_product');
    }
}
