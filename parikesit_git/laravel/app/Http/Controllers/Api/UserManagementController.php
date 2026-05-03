<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\OpdFormReminderService;
use App\Services\UserService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class UserManagementController extends Controller
{
    use ApiResponse;

    protected $userService;

    protected $opdFormReminderService;

    public function __construct(
        UserService $userService,
        OpdFormReminderService $opdFormReminderService,
    ) {
        $this->userService = $userService;
        $this->opdFormReminderService = $opdFormReminderService;
    }

    public function index(Request $request)
    {
        $sortBy = $request->get('sort', 'created_at');
        $sortDirection = $request->get('direction', 'desc');
        $search = $request->get('search', '');
        $perPage = $request->get('per_page', 15);

        $users = $this->userService->getAllUsers($search, $sortBy, $sortDirection, $perPage);

        return UserResource::collection($users);
    }

    public function store(StoreUserRequest $request)
    {
        $user = $this->userService->createUser($request->validated());

        return $this->successResponse(new UserResource($user), 'User created successfully', 201);
    }

    public function show(User $user)
    {
        return $this->successResponse(new UserResource($user));
    }

    public function update(UpdateUserRequest $request, User $user)
    {
        $updatedUser = $this->userService->updateUser($user, $request->validated());

        return $this->successResponse(new UserResource($updatedUser), 'User updated successfully');
    }

    public function destroy(User $user)
    {
        $this->userService->deleteUser($user);

        return $this->successResponse(null, 'User deleted successfully');
    }

    public function resetPassword(User $user)
    {
        $temporaryPassword = $this->userService->resetPassword($user);

        return $this->successResponse(
            ['temporary_password' => $temporaryPassword],
            'Password sementara berhasil dibuat dan seluruh token aktif telah dicabut.',
        );
    }

    public function triggerOpdReminder(Request $request, User $user)
    {
        if ($user->role !== 'opd') {
            return $this->errorResponse('Reminder hanya dapat dikirim ke user OPD.', 422);
        }

        $result = $this->opdFormReminderService->sendManualReminderForUser(
            $user,
            (int) $request->user()->id,
        );

        return $this->successResponse(
            $result,
            $result['message'] ?? 'Reminder diproses.',
        );
    }
}
