<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Size extends Model
{
    protected $fillable = ['name'];

    // Relaciones
    public function products()
    {
        return $this->hasMany(Product::class);
    }
}