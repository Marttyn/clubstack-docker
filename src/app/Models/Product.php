<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Ramsey\Uuid\Uuid;

class Product extends Model
{
    /**
     * Table name
     *
     * @var string $table
     */
    protected string $table = 'product';

    /**
     * Set the primary key type as string to accommodate the UUID
     *
     * @var string $keyType
     */
    protected string $keyType = 'string';

    /**
     * Model attributes that can be mass modified
     *
     * @var string[] $fillable
     */
    protected array $fillable = [
        'stock_available'
    ];

    /**
     * As the UUID is being stored as binary to have a better performance, this is needed to convert the UUID back to a string
     *
     * @param $value
     * @return mixed
     */
    public function getIdAttribute($value): mixed
    {
        return Uuid::fromBytes($value);
    }

    /**
     * Many-to-many relationship with orders
     *
     * @return mixed
     */
    public function orders(): mixed
    {
        return $this->belongsToMany(Order::class, 'order_has_product')->withPivot('quantity');
    }
}
