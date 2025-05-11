<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'price',
        'stock',
        'category_id',
        'size_id',
        'gender',
        'color', 
        'brand', 
        'main_image',
        'images'
    ];

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

    public function promotions()
    {
        return $this->belongsToMany(Promotion::class, 'product_promotion', 'product_id', 'promotion_id');
    }

    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }

    public static function boot()
    {
        parent::boot();

        static::creating(function ($product) {
            $slug = Str::slug($product->name);
            $originalSlug = $slug;
            $count = 1;

            while (self::where('slug', $slug)->exists()) {
                $slug = "{$originalSlug}-" . $count++;
            }
            $product->slug = $slug;
        });

        static::updating(function ($product) {
            $slug = Str::slug($product->name);
            $originalSlug = $slug;
            $count = 1;

            while (self::where('slug', $slug)->where('id', '!=', $product->id)->exists()) {
                $slug = "{$originalSlug}-" . $count++;
            }
            $product->slug = $slug;
        });
    }

    public function getRouteKeyName()
    {
        return 'slug';
    }
}