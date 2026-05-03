<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\DashboardService;
use App\Http\Resources\DashboardStatsResource;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    protected $dashboardService;

    public function __construct(DashboardService $dashboardService)
    {
        $this->dashboardService = $dashboardService;
    }

    public function getStats()
    {
        $stats = $this->dashboardService->getStats();
        $progressData = $this->dashboardService->getProgressData();

        return new DashboardStatsResource([
            'stats' => $stats,
            'progress_data' => $progressData,
        ]);
    }

    public function getOPDPerformance()
    {
        // Placeholder for charts logic - currently mirroring aggregate data
        $progressData = $this->dashboardService->getProgressData();
        return response()->json($progressData);
    }

    public function getAssessmentProgress()
    {
        $progressData = $this->dashboardService->getAssessmentProgressPage(request());
        return response()->json($progressData);
    }
}
