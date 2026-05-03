<?php

namespace App\Http\Controllers;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;

class OpdNotificationController extends Controller
{
    public function index(Request $request)
    {
        abort_unless($request->user()?->role === 'admin', 403);

        $sortBy = $request->get('sort', 'created_at');
        $sortDirection = $request->get('direction', 'desc');
        $search = $request->get('search', '');

        $allowedSorts = ['name', 'email', 'created_at'];
        if (! in_array($sortBy, $allowedSorts, true)) {
            $sortBy = 'created_at';
        }

        if (! in_array($sortDirection, ['asc', 'desc'], true)) {
            $sortDirection = 'desc';
        }

        $users = User::query()
            ->where('role', 'opd')
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($nestedQuery) use ($search) {
                    $nestedQuery->where('name', 'like', "%{$search}%")
                        ->orWhere('email', 'like', "%{$search}%");
                });
            })
            ->orderBy($sortBy, $sortDirection)
            ->paginate(15)
            ->withQueryString();

        if ($request->ajax()) {
            return response()->json([
                'users' => $users->map(function (User $user) {
                    return [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'created_at' => Carbon::parse($user->created_at)->locale('id')->isoFormat('dddd, D MMMM Y'),
                    ];
                }),
                'count' => $users->count(),
                'search' => $search,
                'sortBy' => $sortBy,
                'sortDirection' => $sortDirection,
                'pagination' => [
                    'from' => $users->firstItem(),
                    'to' => $users->lastItem(),
                    'total' => $users->total(),
                    'current_page' => $users->currentPage(),
                    'last_page' => $users->lastPage(),
                    'links_html' => $users->onEachSide(1)->links()->toHtml(),
                ],
            ]);
        }

        return view('dashboard.notifications.opd-index', compact('users', 'sortBy', 'sortDirection', 'search'));
    }
}
