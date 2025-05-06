<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Promotion extends Model
{
    protected $fillable = ['name', 'discount_percentage', 'start_date', 'end_date'];

    // Relación muchos a muchos con Product
    public function products()
    {
        return $this->belongsToMany(Product::class, 'product_promotion', 'promotion_id', 'product_id');
    }
}