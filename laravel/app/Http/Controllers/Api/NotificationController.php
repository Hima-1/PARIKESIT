<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\InboxNotification;
use App\Support\InputSanitizer;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $perPage = InputSanitizer::safeIntRange($request->get('per_page'), 10, 1, 50);
        $notifications = $request->user()
            ->inboxNotifications()
            ->whereNull('hidden_at')
            ->latest()
            ->paginate($perPage);

        $notifications->setCollection(
            $notifications->getCollection()
                ->map(fn (InboxNotification $notification) => $this->transformNotification($notification))
        );

        return response()->json($this->transformPaginatedNotifications($notifications));
    }

    public function markAsRead(Request $request, InboxNotification $notification)
    {
        $this->abortUnlessVisibleToUser($request, $notification);

        if (! $notification->is_read) {
            $notification->forceFill([
                'is_read' => true,
                'read_at' => now(),
            ])->save();
        }

        return response()->json([
            'data' => $this->transformNotification($notification->fresh()),
        ]);
    }

    public function markAllAsRead(Request $request)
    {
        $request->user()
            ->inboxNotifications()
            ->whereNull('hidden_at')
            ->where('is_read', false)
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);

        return response()->json([
            'message' => 'Semua notifikasi telah dibaca',
        ]);
    }

    public function destroy(Request $request, InboxNotification $notification)
    {
        abort_unless($notification->user_id === $request->user()->id, 404);

        if ($notification->hidden_at === null) {
            $notification->forceFill([
                'hidden_at' => now(),
            ])->save();
        }

        return response()->json([
            'message' => 'Notifikasi dihapus',
        ]);
    }

    public function hideRead(Request $request)
    {
        $request->user()
            ->inboxNotifications()
            ->whereNull('hidden_at')
            ->where('is_read', true)
            ->update([
                'hidden_at' => now(),
            ]);

        return response()->json([
            'message' => 'Semua notifikasi yang sudah dibaca dihapus',
        ]);
    }

    private function abortUnlessVisibleToUser(Request $request, InboxNotification $notification): void
    {
        abort_unless(
            $notification->user_id === $request->user()->id
            && $notification->hidden_at === null,
            404
        );
    }

    private function transformNotification(InboxNotification $notification): array
    {
        return [
            'id' => (string) $notification->id,
            'title' => $notification->title,
            'body' => $notification->body,
            'type' => $notification->type,
            'data' => $notification->data ?? [],
            'is_read' => $notification->is_read,
            'created_at' => $notification->created_at?->toISOString(),
        ];
    }

    private function transformPaginatedNotifications(LengthAwarePaginator $notifications): array
    {
        return [
            'data' => $notifications->items(),
            'meta' => [
                'current_page' => $notifications->currentPage(),
                'last_page' => $notifications->lastPage(),
                'per_page' => $notifications->perPage(),
                'total' => $notifications->total(),
                'from' => $notifications->firstItem(),
                'to' => $notifications->lastItem(),
                'path' => $notifications->path(),
            ],
            'links' => [
                'first' => $notifications->url(1) ?? '',
                'last' => $notifications->url($notifications->lastPage()) ?? '',
                'prev' => $notifications->previousPageUrl(),
                'next' => $notifications->nextPageUrl(),
            ],
        ];
    }
}
