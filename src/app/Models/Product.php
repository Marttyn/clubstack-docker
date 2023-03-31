<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Ramsey\Uuid\Uuid;

class Product extends Model
{
    protected $table = 'product';

    protected $keyType = 'string';

    protected $fillable = [
        'stock_available'
    ];

    public function getIdAttribute($value)
    {
        return Uuid::fromBytes($value);
    }

    public function orders()
    {
        return $this->belongsToMany(Order::class, 'order_has_product')->withPivot('quantity');
    }
}
