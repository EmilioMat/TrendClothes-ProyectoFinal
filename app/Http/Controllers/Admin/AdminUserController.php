<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;


class AdminUserController extends Controller
{
    // Listar usuarios con paginación
    // Listar usuarios con paginación
    public function index(Request $request)
    {
        $query = User::orderBy('created_at', 'desc');

        // Búsqueda
        if ($request->has('search') && !empty($request->search)) {
            $query->where('name', 'like', '%' . $request->search . '%')
                ->orWhere('email', 'like', '%' . $request->search . '%');
        }

        $users = $query->paginate(10)->withQueryString();

        $users->getCollection()->transform(function ($user) {
            $user->avatar_url = $user->avatar ? Storage::url($user->avatar) : null;
            return $user;
        });

        return Inertia::render('Admin/Users/Index', [
            'users' => $users,
            'filters' => $request->only(['search'])
        ]);
    }

    // Crear usuario
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('users', 'name'),
            ],
            'email' => [
                'required',
                'email',
                'max:255',
                Rule::unique('users'),
            ],
            'password' => 'required|string|min:8|confirmed',
            'role' => 'required|in:admin,client',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ], [
            // ... mensajes de validación ...
        ]);

        if ($validator->fails()) {
            return redirect()
                ->back()
                ->withErrors($validator)
                ->withInput();
        }

        // Crear el usuario con el rol seleccionado
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'role' => $request->role, // Usar el rol del formulario
        ]);

        // Guardar avatar si existe
        if ($request->hasFile('avatar')) {
            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $path; // No need for str_replace since store() with 'public' disk returns the full path
            $user->save();
        }

        return redirect()->route('admin.users.index')
            ->with('success', 'Usuario creado correctamente');
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            // ... reglas de validación ...
        ], [
            // ... mensajes de validación ...
        ]);

        if ($validator->fails()) {
            return redirect()
                ->back()
                ->withErrors($validator)
                ->withInput();
        }

        // Actualizar datos básicos incluyendo el rol
        $user->update([
            'name' => $request->name,
            'email' => $request->email,
            'role' => $request->role, // Usar el rol del formulario
        ]);

        // Actualizar contraseña si se proporcionó
        if ($request->filled('password')) {
            $user->password = bcrypt($request->password);
            $user->save();
        }

        // Actualizar avatar si se proporcionó
        if ($request->hasFile('avatar')) {
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }
            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $path;
            $user->save();
        }

        return redirect()->route('admin.users.index')
            ->with('success', 'Usuario actualizado correctamente');
    }

    // Eliminar usuario
    public function destroy($id)
    {
        $user = User::findOrFail($id);

        if ($user->role === 'admin' && User::where('role', 'admin')->count() <= 1) {
            return redirect()->back()
                ->with('error', 'No se puede eliminar el último administrador');
        }

        // Delete avatar if exists
        if ($user->avatar) {
            Storage::disk('public')->delete($user->avatar);
        }

        $user->delete();

        return redirect()->route('admin.users.index')->with('success', 'Usuario eliminado correctamente');
    }

    // Eliminar múltiples usuarios
public function deleteMultiple(Request $request)
{
    $request->validate([
        'ids' => 'required|array',
        'ids.*' => 'exists:users,id',
    ]);

    // Contar cuántos administradores serían eliminados
    $adminUsers = User::whereIn('id', $request->ids)->where('role', 'admin')->count();
    $totalAdmins = User::where('role', 'admin')->count();

    // Si se intenta eliminar a todos los administradores, se impide
    if ($adminUsers > 0 && ($totalAdmins - $adminUsers) <= 0) {
        return redirect()->back()
            ->with('error', 'No se pueden eliminar todos los administradores');
    }

    // Eliminar avatares de todos los usuarios seleccionados (admin y no admin)
    $users = User::whereIn('id', $request->ids)->get();
    foreach ($users as $user) {
        if ($user->avatar) {
            Storage::disk('public')->delete($user->avatar);
        }
    }

    // Eliminar todos los usuarios seleccionados
    $usersToDelete = User::whereIn('id', $request->ids)->delete();

    return redirect()->back()->with('success', 'Usuarios eliminados correctamente');
}


    // Eliminar todos los usuarios (solo clientes)
    public function deleteAll()
    {
        $users = User::where('role', '!=', 'admin')->get();
        foreach ($users as $user) {
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }
        }

        $deletedCount = User::where('role', '!=', 'admin')->delete();

        if ($deletedCount === 0) {
            return redirect()->back()
                ->with('error', 'No hay usuarios clientes para eliminar');
        }

        return redirect()->back()->with('success', 'Todos los usuarios clientes eliminados correctamente');
    }
}
