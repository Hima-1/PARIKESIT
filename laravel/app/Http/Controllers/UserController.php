<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Services\OpdFormReminderService;
use App\Services\UserService;
use App\Support\InputSanitizer;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    protected $userService;

    protected $opdFormReminderService;

    public function __construct(UserService $userService, OpdFormReminderService $opdFormReminderService)
    {
        $this->middleware('can:admin');
        $this->userService = $userService;
        $this->opdFormReminderService = $opdFormReminderService;
    }

    public function index(Request $request)
    {
        $sortBy = InputSanitizer::sortBy($request->get('sort'), ['created_at', 'name', 'email', 'role'], 'created_at');
        $sortDirection = InputSanitizer::sortDirection($request->get('direction'));
        $search = InputSanitizer::safeSearch($request->get('search', ''));

        $users = $this->userService->getAllUsers($search, $sortBy, $sortDirection);

        if ($request->ajax()) {
            return response()->json([
                'users' => $users->map(function ($user) {
                    return [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'role' => $user->role,
                        'created_at' => Carbon::parse($user->created_at)->locale('id')->isoFormat('dddd, D MMMM Y'),
                    ];
                }),
                'count' => $users->count(),
                'search' => $search,
                'sortBy' => $sortBy,
                'sortDirection' => $sortDirection,
            ]);
        }

        return view('dashboard.users.user-index', compact('users', 'sortBy', 'sortDirection', 'search'));
    }

    public function create()
    {
        return view('dashboard.users.user-create');
    }

    public function store(Request $request)
    {
        $request->merge([
            'name' => InputSanitizer::plainText($request->input('name'), 255),
            'email' => InputSanitizer::email($request->input('email')),
            'alamat' => InputSanitizer::plainText($request->input('alamat'), 1000),
            'nomor_telepon' => InputSanitizer::phone($request->input('nomor_telepon')),
        ]);

        $data = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|string|in:admin,opd,walidata',
            'alamat' => 'required|string|max:1000',
            'nomor_telepon' => ['required', 'string', 'max:20', 'regex:/^[0-9+()\-\s]{6,20}$/'],
        ]);

        $this->userService->createUser($data);

        return redirect()->route('user.index')->with('success', 'User created successfully');
    }

    public function show(User $user)
    {
        return view('dashboard.users.user-show', compact('user'));
    }

    public function edit(User $user)
    {
        return view('dashboard.users.user-edit', compact('user'));
    }

    public function update(Request $request, User $user)
    {
        $request->merge([
            'name' => InputSanitizer::plainText($request->input('name'), 255),
            'email' => InputSanitizer::email($request->input('email')),
            'alamat' => InputSanitizer::plainText($request->input('alamat'), 1000),
            'nomor_telepon' => InputSanitizer::phone($request->input('nomor_telepon')),
        ]);

        $data = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,'.$user->id,
            'password' => 'nullable|string|min:8',
            'role' => 'required|string|in:admin,opd,walidata',
            'alamat' => 'required|string|max:1000',
            'nomor_telepon' => ['required', 'string', 'max:20', 'regex:/^[0-9+()\-\s]{6,20}$/'],
        ]);

        $this->userService->updateUser($user, $data);

        return redirect()->route('user.index')->with('success', 'User berhasil diperbarui');
    }

    public function destroy(User $user)
    {
        $this->userService->deleteUser($user);

        return redirect()->route('user.index')->with('success', 'User deleted successfully');
    }

    public function resetPassword(User $user)
    {
        $temporaryPassword = $this->userService->resetPassword($user);

        return redirect()->back()->with(
            'success',
            'Password sementara user: '.$temporaryPassword.'. Seluruh token aktif telah dicabut.',
        );
    }

    public function triggerOpdReminder(User $user)
    {
        if ($user->role !== 'opd') {
            return redirect()
                ->route('opd-notifications.index')
                ->with('error', 'Reminder hanya dapat dikirim ke user OPD.');
        }

        $result = $this->opdFormReminderService->sendManualReminderForUser(
            $user,
            (int) Auth::id(),
        );

        return redirect()
            ->route('opd-notifications.index')
            ->with('success', $result['message'] ?? 'Reminder diproses.');
    }

    public function triggerBulkOpdReminder(Request $request)
    {
        $validated = $request->validate([
            'user_ids' => ['required', 'array', 'min:1'],
            'user_ids.*' => ['integer', 'distinct'],
        ]);

        $selectedIds = collect($validated['user_ids'])
            ->map(static fn ($id) => (int) $id)
            ->unique()
            ->values();

        $users = User::query()
            ->whereIn('id', $selectedIds)
            ->get()
            ->keyBy('id');

        $processed = 0;
        $successful = 0;
        $skipped = 0;

        foreach ($selectedIds as $userId) {
            $user = $users->get($userId);

            if (! $user || $user->role !== 'opd') {
                $skipped++;

                continue;
            }

            $processed++;

            $result = $this->opdFormReminderService->sendManualReminderForUser(
                $user,
                (int) Auth::id(),
            );

            if (($result['incomplete_form_count'] ?? 0) > 0) {
                $successful++;
            } else {
                $skipped++;
            }
        }

        $message = "Reminder bulk diproses untuk {$processed} user OPD. Berhasil: {$successful}. Dilewati: {$skipped}.";

        return redirect()
            ->route('opd-notifications.index')
            ->with('success', $message);
    }
}
