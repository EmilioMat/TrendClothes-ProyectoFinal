<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Promotion extends Model
{
    protected $fillable = ['name', 'discount_percentage', 'start_date', 'end_date'];

    // Relaciones
    // Nota: No definimos relaciones directas por ahora, pero podrías añadir una relación con productos si las promociones se aplican a productos específicos.
    public function products()
    {
        return $this->belongsToMany(Product::class, 'product_promotion'); // Relación muchos a muchos (requiere tabla pivote).
    }
}