<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;


class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'price',
        'category_id',
        'gender',
        'color',
        'brand',
        'main_image',
        'images',
        'published',
        'stock'
    ];

    // Relaciones
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function sizes()
    {
        return $this->belongsToMany(Size::class, 'product_size')
            ->withPivot('stock')
            ->withTimestamps();
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

    public function product_images()
    {
        return $this->hasMany(ProductImage::class);
    }

    // Método para verificar disponibilidad
    public function hasStock($quantity, $sizeId = null)
    {
        if ($sizeId) {
            $size = $this->sizes()->where('size_id', $sizeId)->first();
            if (!$size) {
                // Fallback to check by size name (for backward compatibility)
                $size = $this->sizes()->where('name', $sizeId)->first();
            }
            $sizeStock = $size?->pivot->stock ?? 0;
            return $sizeStock >= $quantity;
        }
        return $this->stock >= $quantity;
    }

    // Método para reducir el stock
    public function decreaseStock($quantity, $sizeId = null)
    {
        if ($sizeId) {
            $size = $this->sizes()->where('size_id', $sizeId)->first();
            if (!$size) {
                // Fallback to size name
                $size = $this->sizes()->where('name', $sizeId)->first();
            }
            if ($size) {
                // Update stock in product_size pivot table
                $this->sizes()->updateExistingPivot($size->id, [
                    'stock' => DB::raw('stock - ' . (int)$quantity)
                ]);
            }
        } else {
            $this->decrement('stock', $quantity);
        }
    }

    // Método para incrementar el stock (used in CheckoutController@success)
    public function increaseStock($quantity, $sizeId = null)
    {
        if ($sizeId) {
            $size = $this->sizes()->where('size_id', $sizeId)->first();
            if (!$size) {
                $size = $this->sizes()->where('name', $sizeId)->first();
            }
            if ($size) {
                $this->sizes()->updateExistingPivot($size->id, [
                    'stock' => DB::raw('stock + ' . (int)$quantity)
                ]);
            }
        } else {
            $this->increment('stock', $quantity);
        }
    }

    public function scopeFiltered($query, array $filters = [])
    {
        return $query
            ->when(!empty($filters['colors']), function ($q) use ($filters) {
                $q->whereIn('color', $filters['colors']);
            })
            ->when(!empty($filters['genders']), function ($q) use ($filters) {
                $q->whereIn('gender', $filters['genders']);
            })
            ->when(!empty($filters['brands']), function ($q) use ($filters) {
                $q->whereIn('brand', $filters['brands']);
            })
            ->when(!empty($filters['sizes']), function ($q) use ($filters) {
                $q->whereHas('sizes', function ($query) use ($filters) {
                    $query->whereIn('sizes.id', $filters['sizes'])
                          ->where('product_size.stock', '>', 0);
                });
            })
            ->when(isset($filters['price_min']), function ($q) use ($filters) {
                $q->where('price', '>=', $filters['price_min']);
            })
            ->when(isset($filters['price_max']), function ($q) use ($filters) {
                $q->where('price', '<=', $filters['price_max']);
            })
            ->when(!empty($filters['sort']), function ($q) use ($filters) {
                switch ($filters['sort']) {
                    case 'price_asc':
                        $q->orderBy('price', 'asc');
                        break;
                    case 'price_desc':
                        $q->orderBy('price', 'desc');
                        break;
                    case 'newest':
                        $q->orderBy('created_at', 'desc');
                        break;
                }
            });
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