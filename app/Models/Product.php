<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = ['name', 'description', 'price', 'stock', 'category_id', 'size_id'];

    // Relaciones
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function size()
    {
        return $this->belongsTo(Size::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    // Relación muchos a muchos con Promotion
    public function promotions()
    {
        return $this->belongsToMany(Promotion::class, 'product_promotion', 'product_id', 'promotion_id');
    }
}