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
            'name.required' => 'El nombre es obligatorio',
            'name.string' => 'El nombre debe ser una cadena de texto',
            'name.max' => 'El nombre no puede exceder los 255 caracteres',
            'name.unique' => 'Este nombre de usuario ya está en uso',

            'email.required' => 'El correo electrónico es obligatorio',
            'email.email' => 'Debe ingresar un correo electrónico válido',
            'email.max' => 'El correo electrónico no puede exceder los 255 caracteres',
            'email.unique' => 'Este correo electrónico ya está registrado',

            'password.required' => 'La contraseña es obligatoria',
            'password.string' => 'La contraseña debe ser una cadena de texto',
            'password.min' => 'La contraseña debe tener al menos 8 caracteres',
            'password.confirmed' => 'Las contraseñas no coinciden',

            'role.required' => 'El rol es obligatorio',
            'role.in' => 'El rol seleccionado no es válido',

            'avatar.image' => 'El archivo debe ser una imagen válida',
            'avatar.mimes' => 'La imagen debe ser de tipo: jpeg, png, jpg o gif',
            'avatar.max' => 'La imagen no debe pesar más de 2MB'
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
            'role' => $request->role,
        ]);

        // Guardar avatar si existe
        if ($request->hasFile('avatar')) {
            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $path;
            $user->save();
        }

        return redirect()->route('admin.users.index')
            ->with('success', 'Usuario creado correctamente');
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('users', 'name')->ignore($user->id),
            ],
            'email' => [
                'required',
                'email',
                'max:255',
                Rule::unique('users')->ignore($user->id),
            ],
            'password' => 'nullable|string|min:8|confirmed',
            'role' => 'required|in:admin,client',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ], [
            'name.required' => 'El nombre es obligatorio',
            'name.string' => 'El nombre debe ser una cadena de texto',
            'name.max' => 'El nombre no puede exceder los 255 caracteres',
            'name.unique' => 'Este nombre de usuario ya está en uso',

            'email.required' => 'El correo electrónico es obligatorio',
            'email.email' => 'Debe ingresar un correo electrónico válido',
            'email.max' => 'El correo electrónico no puede exceder los 255 caracteres',
            'email.unique' => 'Este correo electrónico ya está registrado',

            'password.string' => 'La contraseña debe ser una cadena de texto',
            'password.min' => 'La contraseña debe tener al menos 8 caracteres',
            'password.confirmed' => 'Las contraseñas no coinciden',

            'role.required' => 'El rol es obligatorio',
            'role.in' => 'El rol seleccionado no es válido',

            'avatar.image' => 'El archivo debe ser una imagen válida',
            'avatar.mimes' => 'La imagen debe ser de tipo: jpeg, png, jpg o gif',
            'avatar.max' => 'La imagen no debe pesar más de 2MB'
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
            'role' => $request->role,
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
        ], [
            'ids.required' => 'Debe seleccionar al menos un usuario para eliminar',
            'ids.array' => 'Los datos deben ser un arreglo de IDs',
            'ids.*.exists' => 'Uno o más usuarios seleccionados no existen'
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
