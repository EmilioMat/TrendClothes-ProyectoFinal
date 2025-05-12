<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureIsAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        
        if (!$user || ($user->role !== 'admin' && !$user->isAdmin)) {
            abort(403, 'Unauthorized action.');
        }
        
        return $next($request);
    }
}